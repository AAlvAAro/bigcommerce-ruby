# frozen_string_literal: true

module Bigcommerce
  module Resources
    class InventoryAdjustments < Resource
      # PUT /inventory/adjustments/absolute
      # Set inventory to an absolute quantity. Identifies items by location_id and
      # one of: sku, variant_id, or product_id.
      # @param items [Array<Hash>] Array of adjustment items
      #   Each hash must include :location_id, :quantity, and one of :sku, :variant_id, or :product_id
      # @param reason [String] Optional reason for the adjustment
      # @return [Bigcommerce::Response]
      def absolute(items:, reason: nil)
        body = { items: items }
        body[:reason] = reason if reason
        put("/inventory/adjustments/absolute", body)
      end

      # POST /inventory/adjustments/relative
      # Adjust inventory by a relative quantity (positive to add, negative to subtract).
      # Identifies items by location_id and one of: sku, variant_id, or product_id.
      # @param items [Array<Hash>] Array of adjustment items
      #   Each hash must include :location_id, :quantity, and one of :sku, :variant_id, or :product_id
      # @param reason [String] Optional reason for the adjustment
      # @return [Bigcommerce::Response]
      def relative(items:, reason: nil)
        body = { items: items }
        body[:reason] = reason if reason
        post("/inventory/adjustments/relative", body)
      end

      private

      def api_version
        :v3
      end
    end
  end
end
