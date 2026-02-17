# frozen_string_literal: true

module Bigcommerce
  module Resources
    class OrderShipments < Resource
      def initialize(connection, order_id)
        super(connection)
        @order_id = order_id
      end

      # GET /orders/:order_id/shipments
      # @param params [Hash] Query parameters
      # @option params [Integer] :page Page number (default: 1)
      # @option params [Integer] :limit Results per page (default: 50)
      # @return [Bigcommerce::Response]
      def list(**params)
        get("/orders/#{@order_id}/shipments", params)
      end

      # GET /orders/:order_id/shipments/:id
      # @param id [Integer] Shipment ID
      # @return [Bigcommerce::Response]
      def find(id)
        get("/orders/#{@order_id}/shipments/#{id}")
      end

      # POST /orders/:order_id/shipments
      # @param attributes [Hash] Shipment attributes
      # @option attributes [Integer] :order_address_id Required - shipping address ID
      # @option attributes [Array<Hash>] :items Required - [{order_product_id:, quantity:}]
      # @option attributes [String] :tracking_number Tracking number
      # @option attributes [String] :shipping_provider Shipping provider name
      # @option attributes [String] :tracking_carrier Tracking carrier
      # @option attributes [String] :tracking_link Tracking URL
      # @option attributes [String] :merchant_shipping_cost Shipping cost (decimal string)
      # @return [Bigcommerce::Response]
      def create(**attributes)
        post("/orders/#{@order_id}/shipments", attributes)
      end

      # PUT /orders/:order_id/shipments/:id
      # @param id [Integer] Shipment ID
      # @param attributes [Hash] Shipment attributes to update
      # @return [Bigcommerce::Response]
      def update(id, **attributes)
        put("/orders/#{@order_id}/shipments/#{id}", attributes)
      end

      # DELETE /orders/:order_id/shipments/:id
      # @param id [Integer] Shipment ID
      # @return [Bigcommerce::Response]
      def destroy(id)
        delete("/orders/#{@order_id}/shipments/#{id}")
      end

      # DELETE /orders/:order_id/shipments
      # Deletes all shipments for the order
      # @return [Bigcommerce::Response]
      def destroy_all
        delete("/orders/#{@order_id}/shipments")
      end

      # GET /orders/:order_id/shipments/count
      # @return [Bigcommerce::Response]
      def count
        get("/orders/#{@order_id}/shipments/count")
      end
    end
  end
end
