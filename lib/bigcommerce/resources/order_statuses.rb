# frozen_string_literal: true

module Bigcommerce
  module Resources
    class OrderStatuses < Resource
      # GET /order_statuses
      # @return [Bigcommerce::Response]
      def list
        get("/order_statuses")
      end

      # GET /order_statuses/:id
      # @param id [Integer] Status ID
      # @return [Bigcommerce::Response]
      def find(id)
        get("/order_statuses/#{id}")
      end
    end
  end
end
