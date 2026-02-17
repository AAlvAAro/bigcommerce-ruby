# frozen_string_literal: true

module Bigcommerce
  module Resources
    class OrderShippingAddresses < Resource
      def initialize(connection, order_id)
        super(connection)
        @order_id = order_id
      end

      # GET /orders/:order_id/shipping_addresses
      # @param params [Hash] Query parameters
      # @option params [Integer] :page Page number (default: 1)
      # @option params [Integer] :limit Results per page (default: 50)
      # @return [Bigcommerce::Response]
      def list(**params)
        get("/orders/#{@order_id}/shipping_addresses", params)
      end

      # GET /orders/:order_id/shipping_addresses/:id
      # @param id [Integer] Shipping address ID
      # @return [Bigcommerce::Response]
      def find(id)
        get("/orders/#{@order_id}/shipping_addresses/#{id}")
      end

      # PUT /orders/:order_id/shipping_addresses/:id
      # @param id [Integer] Shipping address ID
      # @param attributes [Hash] Address attributes to update
      # @return [Bigcommerce::Response]
      def update(id, **attributes)
        put("/orders/#{@order_id}/shipping_addresses/#{id}", attributes)
      end
    end
  end
end
