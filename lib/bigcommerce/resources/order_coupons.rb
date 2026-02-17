# frozen_string_literal: true

module Bigcommerce
  module Resources
    class OrderCoupons < Resource
      def initialize(connection, order_id)
        super(connection)
        @order_id = order_id
      end

      # GET /orders/:order_id/coupons
      # @param params [Hash] Query parameters
      # @option params [Integer] :page Page number (default: 1)
      # @option params [Integer] :limit Results per page (default: 50)
      # @return [Bigcommerce::Response]
      def list(**params)
        get("/orders/#{@order_id}/coupons", params)
      end
    end
  end
end
