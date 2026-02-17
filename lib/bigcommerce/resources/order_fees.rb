# frozen_string_literal: true

module Bigcommerce
  module Resources
    class OrderFees < Resource
      def initialize(connection, order_id)
        super(connection)
        @order_id = order_id
      end

      # GET /orders/:order_id/fees
      # @param id [Integer] Order ID
      # @return [Bigcommerce::Response]
      def list
        get("/orders/#{@order_id}/fees")
      end
    end
  end
end
