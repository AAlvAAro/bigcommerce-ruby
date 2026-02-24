# frozen_string_literal: true

RSpec.describe Bigcommerce::Resources::InventoryItems do
  let(:client) { build_client }
  let(:inventory_items) { client.inventory_items }

  describe "#list" do
    it "fetches inventory across all locations" do
      stub_api(:get, "/inventory/items", api_version: :v3, body: {
        data: [
          {
            identity: { sku: "SKU-001", variant_id: 10, product_id: 1 },
            locations: [
              { location_id: 1, available_to_sell: 50, total_inventory_onhand: 55 }
            ]
          }
        ],
        meta: { pagination: { total: 1, current_page: 1, total_pages: 1 } }
      })

      response = inventory_items.list
      expect(response.body[:data].length).to eq(1)
      expect(response.body[:data].first[:identity][:sku]).to eq("SKU-001")
    end

    it "supports filtering by SKU" do
      stub_api(:get, "/inventory/items",
               api_version: :v3,
               query: { "sku:in" => "SKU-001,SKU-002" },
               body: { data: [], meta: {} })

      response = inventory_items.list("sku:in": "SKU-001,SKU-002")
      expect(response.success?).to be true
    end

    it "supports filtering by location_id" do
      stub_api(:get, "/inventory/items",
               api_version: :v3,
               query: { "location_id:in" => "1,2" },
               body: { data: [], meta: {} })

      response = inventory_items.list("location_id:in": "1,2")
      expect(response.success?).to be true
    end

    it "supports pagination" do
      stub_api(:get, "/inventory/items",
               api_version: :v3,
               query: { "page" => "2", "limit" => "10" },
               body: { data: [], meta: {} })

      response = inventory_items.list(page: 2, limit: 10)
      expect(response.success?).to be true
    end
  end

  describe "#list_for_location" do
    it "fetches inventory at a specific location" do
      stub_api(:get, "/inventory/locations/1/items", api_version: :v3, body: {
        data: [
          {
            identity: { sku: "SKU-001", variant_id: 10, product_id: 1 },
            available_to_sell: 50,
            total_inventory_onhand: 55,
            settings: { safety_stock: 5, is_in_stock: true, warning_level: 10 }
          }
        ],
        meta: {}
      })

      response = inventory_items.list_for_location(1)
      expect(response.body[:data].first[:available_to_sell]).to eq(50)
    end

    it "supports filtering by variant_id" do
      stub_api(:get, "/inventory/locations/1/items",
               api_version: :v3,
               query: { "variant_id:in" => "10,20" },
               body: { data: [], meta: {} })

      response = inventory_items.list_for_location(1, "variant_id:in": "10,20")
      expect(response.success?).to be true
    end

    it "raises NotFoundError for invalid location" do
      stub_api(:get, "/inventory/locations/999/items",
               api_version: :v3,
               status: 404,
               body: { title: "Location not found" })

      expect { inventory_items.list_for_location(999) }.to raise_error(Bigcommerce::NotFoundError)
    end
  end

  describe "#update_settings" do
    it "updates inventory settings at a location" do
      stub_api(:put, "/inventory/locations/1/items",
               api_version: :v3,
               body: { transaction_id: "txn-abc-123" })

      response = inventory_items.update_settings(1, settings: [
        { identity: { sku: "SKU-001" }, safety_stock: 5, warning_level: 10 },
        { identity: { variant_id: 20 }, is_in_stock: false }
      ])
      expect(response.body[:transaction_id]).to eq("txn-abc-123")
    end
  end
end
