# frozen_string_literal: true

module Bigcommerce
  module Resources
    class Orders < Resource
      # GET /orders
      # @param params [Hash] Query parameters
      # @option params [Integer] :min_id Minimum order ID
      # @option params [Integer] :max_id Maximum order ID
      # @option params [Float] :min_total Minimum order total
      # @option params [Float] :max_total Maximum order total
      # @option params [Integer] :customer_id Filter by customer ID
      # @option params [String] :email Filter by customer email
      # @option params [Integer] :status_id Filter by status ID
      # @option params [String] :cart_id Filter by cart ID
      # @option params [String] :payment_method Filter by payment method
      # @option params [String] :min_date_created Minimum date created (RFC-2822 or ISO-8601)
      # @option params [String] :max_date_created Maximum date created
      # @option params [String] :min_date_modified Minimum date modified
      # @option params [String] :max_date_modified Maximum date modified
      # @option params [Integer] :page Page number (default: 1)
      # @option params [Integer] :limit Results per page (default: 50)
      # @option params [String] :sort Sort field (id, customer_id, date_created, date_modified, status_id, channel_id, external_id)
      # @option params [Integer] :channel_id Filter by channel ID
      # @option params [String] :external_order_id Filter by external order ID
      # @option params [Array<String>] :include Side-load resources (consignments, consignments.line_items, fees)
      # @return [Bigcommerce::Response]
      def list(**params)
        get("/orders", params)
      end

      # GET /orders/:id
      # @param id [Integer] Order ID
      # @param params [Hash] Query parameters
      # @option params [Array<String>] :include Side-load resources
      # @return [Bigcommerce::Response]
      def find(id, **params)
        get("/orders/#{id}", params)
      end

      # POST /orders
      # @param attributes [Hash] Order attributes
      # @return [Bigcommerce::Response]
      def create(**attributes)
        post("/orders", attributes)
      end

      # PUT /orders/:id
      # @param id [Integer] Order ID
      # @param attributes [Hash] Order attributes to update
      # @return [Bigcommerce::Response]
      def update(id, **attributes)
        put("/orders/#{id}", attributes)
      end

      # DELETE /orders/:id
      # Archives an order
      # @param id [Integer] Order ID
      # @return [Bigcommerce::Response]
      def archive(id)
        delete("/orders/#{id}")
      end

      # DELETE /orders
      # Archives all orders (use with caution)
      # @return [Bigcommerce::Response]
      def archive_all
        delete("/orders")
      end

      # GET /orders/count
      # @param params [Hash] Same filter params as #list (except page/limit/sort/include)
      # @return [Bigcommerce::Response]
      def count(**params)
        get("/orders/count", params)
      end
    end
  end
end
