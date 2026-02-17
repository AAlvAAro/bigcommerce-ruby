# frozen_string_literal: true

module Bigcommerce
  class Resource
    attr_reader :connection

    def initialize(connection)
      @connection = connection
    end

    private

    def get(path, params = {})
      connection.get(path, params)
    end

    def post(path, body = {})
      connection.post(path, body)
    end

    def put(path, body = {})
      connection.put(path, body)
    end

    def delete(path, params = {})
      connection.delete(path, params)
    end
  end
end
