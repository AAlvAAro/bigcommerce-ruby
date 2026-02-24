# frozen_string_literal: true

require "faraday"
require "faraday/retry"
require "json"

module Bigcommerce
  class Connection
    BASE_URL = "https://api.bigcommerce.com/stores"

    def initialize(config)
      @config = config
    end

    def get(path, params = {}, api_version: :v2)
      request(:get, path, params, api_version: api_version)
    end

    def post(path, body = {}, api_version: :v2)
      request(:post, path, body, api_version: api_version)
    end

    def put(path, body = {}, api_version: :v2)
      request(:put, path, body, api_version: api_version)
    end

    def delete(path, params = {}, api_version: :v2)
      request(:delete, path, params, api_version: api_version)
    end

    private

    def request(method, path, payload = {}, api_version: :v2)
      response = connection.run_request(method, "#{base_url(api_version)}#{path}", nil, nil) do |req|
        case method
        when :get, :delete
          req.params = payload if payload.any?
        when :post, :put
          req.body = JSON.generate(payload)
        end
      end

      handle_response(response)
    end

    def connection
      @connection ||= Faraday.new do |f|
        f.request :retry, max: 3, interval: 0.5, backoff_factor: 2,
                          retry_statuses: [429, 500, 502, 503, 504],
                          retry_block: ->(env:, options:, retry_count:, exception:, will_retry_in:) {
                            handle_rate_limit(env) if env&.status == 429
                          }
        f.headers["X-Auth-Token"] = @config.access_token
        f.headers["Content-Type"] = "application/json"
        f.headers["Accept"] = "application/json"
        f.options.timeout = @config.timeout
        f.options.open_timeout = @config.open_timeout
      end
    end

    def base_url(api_version = :v2)
      "#{BASE_URL}/#{@config.store_hash}/#{api_version}"
    end

    def handle_response(faraday_response)
      response = Response.new(faraday_response)

      case faraday_response.status
      when 200..299
        response
      when 401
        raise AuthenticationError.new("Invalid credentials", response: response)
      when 404
        raise NotFoundError.new("Resource not found", response: response)
      when 422
        raise UnprocessableEntityError.new(error_message(response), response: response)
      when 429
        raise RateLimitError.new("Rate limit exceeded", response: response)
      when 500..599
        raise ServerError.new("Server error", response: response)
      else
        raise ApiError.new(
          error_message(response),
          status: faraday_response.status,
          body: response.body,
          response: response
        )
      end
    end

    def error_message(response)
      return "Unknown error" unless response.body.is_a?(Hash)

      response.body[:title] || response.body[:message] || response.body.to_s
    end

    def handle_rate_limit(env)
      reset_ms = env.response_headers&.dig("x-rate-limit-time-reset-ms")
      sleep(reset_ms.to_f / 1000) if reset_ms
    end
  end
end
