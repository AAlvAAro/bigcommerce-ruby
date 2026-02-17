# frozen_string_literal: true

module Bigcommerce
  class Configuration
    attr_accessor :store_hash, :access_token, :timeout, :open_timeout

    def initialize
      @store_hash = nil
      @access_token = nil
      @timeout = 30
      @open_timeout = 10
    end

    def validate!
      raise ConfigurationError, "store_hash is required" if store_hash.nil? || store_hash.empty?
      raise ConfigurationError, "access_token is required" if access_token.nil? || access_token.empty?
    end
  end
end
