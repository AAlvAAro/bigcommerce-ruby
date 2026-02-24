# frozen_string_literal: true

module Bigcommerce
  class Resource
    attr_reader :connection

    def initialize(connection)
      @connection = connection
    end

    private

    def api_version
      :v2
    end

    def get(path, params = {})
      connection.get(path, params, api_version: api_version)
    end

    def post(path, body = {})
      connection.post(path, body, api_version: api_version)
    end

    def put(path, body = {})
      connection.put(path, body, api_version: api_version)
    end

    def delete(path, params = {})
      connection.delete(path, params, api_version: api_version)
    end
  end
end
