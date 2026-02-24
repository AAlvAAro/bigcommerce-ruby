# frozen_string_literal: true

module Bigcommerce
  module Resources
    class InventoryItems < Resource
      # GET /inventory/items
      # Get inventory at all locations.
      # @param params [Hash] Query parameters
      # @option params [String] :"sku:in" Comma-separated SKUs
      # @option params [String] :"variant_id:in" Comma-separated variant IDs
      # @option params [String] :"product_id:in" Comma-separated product IDs
      # @option params [String] :"location_id:in" Comma-separated location IDs
      # @option params [String] :"location_code:in" Comma-separated location codes
      # @option params [Integer] :page Page number
      # @option params [Integer] :limit Items per page
      # @return [Bigcommerce::Response]
      def list(**params)
        get("/inventory/items", params)
      end

      # GET /inventory/locations/:location_id/items
      # Get inventory at a specific location.
      # @param location_id [Integer] Location ID
      # @param params [Hash] Query parameters
      # @option params [String] :"sku:in" Comma-separated SKUs
      # @option params [String] :"variant_id:in" Comma-separated variant IDs
      # @option params [String] :"product_id:in" Comma-separated product IDs
      # @option params [Integer] :page Page number
      # @option params [Integer] :limit Items per page
      # @return [Bigcommerce::Response]
      def list_for_location(location_id, **params)
        get("/inventory/locations/#{location_id}/items", params)
      end

      # PUT /inventory/locations/:location_id/items
      # Update inventory settings (safety_stock, is_in_stock, warning_level, bin_picking_number)
      # for items at a specific location.
      # @param location_id [Integer] Location ID
      # @param settings [Array<Hash>] Array of setting objects
      #   Each hash must include :identity (with :sku, :variant_id, or :product_id)
      #   and at least one of: :safety_stock, :is_in_stock, :warning_level, :bin_picking_number
      # @return [Bigcommerce::Response]
      def update_settings(location_id, settings:)
        put("/inventory/locations/#{location_id}/items", { settings: settings })
      end

      private

      def api_version
        :v3
      end
    end
  end
end
