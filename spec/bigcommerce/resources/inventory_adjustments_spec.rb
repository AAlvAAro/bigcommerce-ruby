# frozen_string_literal: true

RSpec.describe Bigcommerce::Resources::InventoryAdjustments do
  let(:client) { build_client }
  let(:adjustments) { client.inventory_adjustments }

  describe "#absolute" do
    it "sets inventory to an absolute quantity" do
      stub_api(:put, "/inventory/adjustments/absolute",
               api_version: :v3,
               body: { transaction_id: "txn-abs-001" })

      response = adjustments.absolute(items: [
        { location_id: 1, sku: "SKU-001", quantity: 100 },
        { location_id: 1, variant_id: 20, quantity: 50 }
      ])
      expect(response.body[:transaction_id]).to eq("txn-abs-001")
    end

    it "supports a reason" do
      stub_api(:put, "/inventory/adjustments/absolute",
               api_version: :v3,
               body: { transaction_id: "txn-abs-002" })

      response = adjustments.absolute(
        items: [{ location_id: 1, product_id: 5, quantity: 200 }],
        reason: "Annual inventory count"
      )
      expect(response.success?).to be true
    end

    it "raises UnprocessableEntityError for invalid items" do
      stub_api(:put, "/inventory/adjustments/absolute",
               api_version: :v3,
               status: 422,
               body: { title: "Invalid items", status: 422, errors: {} })

      expect {
        adjustments.absolute(items: [{ location_id: 1, quantity: 10 }])
      }.to raise_error(Bigcommerce::UnprocessableEntityError)
    end
  end

  describe "#relative" do
    it "adjusts inventory by a relative quantity" do
      stub_api(:post, "/inventory/adjustments/relative",
               api_version: :v3,
               body: { transaction_id: "txn-rel-001" })

      response = adjustments.relative(items: [
        { location_id: 1, sku: "SKU-001", quantity: -5 },
        { location_id: 2, sku: "SKU-001", quantity: 5 }
      ])
      expect(response.body[:transaction_id]).to eq("txn-rel-001")
    end

    it "supports a reason" do
      stub_api(:post, "/inventory/adjustments/relative",
               api_version: :v3,
               body: { transaction_id: "txn-rel-002" })

      response = adjustments.relative(
        items: [{ location_id: 1, variant_id: 10, quantity: 25 }],
        reason: "Restock from supplier"
      )
      expect(response.success?).to be true
    end
  end
end
