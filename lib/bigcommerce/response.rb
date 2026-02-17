# frozen_string_literal: true

module Bigcommerce
  class Response
    attr_reader :status, :headers, :body

    def initialize(faraday_response)
      @status = faraday_response.status
      @headers = faraday_response.headers
      @body = parse_body(faraday_response.body)
    end

    def success?
      (200..299).cover?(status)
    end

    def rate_limit
      headers["x-rate-limit-requests-left"]&.to_i
    end

    def rate_limit_reset
      headers["x-rate-limit-time-reset-ms"]&.to_i
    end

    private

    def parse_body(raw)
      return nil if raw.nil? || raw.empty?

      JSON.parse(raw, symbolize_names: true)
    rescue JSON::ParserError
      raw
    end
  end
end
