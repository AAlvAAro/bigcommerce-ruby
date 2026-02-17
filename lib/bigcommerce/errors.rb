# frozen_string_literal: true

module Bigcommerce
  class Error < StandardError
    attr_reader :response

    def initialize(message = nil, response: nil)
      @response = response
      super(message)
    end
  end

  class ConfigurationError < Error; end
  class AuthenticationError < Error; end
  class NotFoundError < Error; end
  class RateLimitError < Error; end
  class UnprocessableEntityError < Error; end
  class ServerError < Error; end

  class ApiError < Error
    attr_reader :status, :body

    def initialize(message = nil, status: nil, body: nil, response: nil)
      @status = status
      @body = body
      super(message, response: response)
    end

    def to_s
      "#{status}: #{message}"
    end
  end
end
