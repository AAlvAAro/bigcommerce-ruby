# frozen_string_literal: true

RSpec.describe Bigcommerce::Resources::OrderProducts do
  let(:client) { build_client }
  let(:order_products) { client.order_products(100) }

  describe "#list" do
    it "fetches products for an order" do
      stub_api(:get, "/orders/100/products", body: [
        { id: 1, name: "Coffee Beans", quantity: 2 },
        { id: 2, name: "Grinder", quantity: 1 }
      ])

      response = order_products.list
      expect(response.body.length).to eq(2)
      expect(response.body.first[:name]).to eq("Coffee Beans")
    end

    it "supports pagination" do
      stub_api(:get, "/orders/100/products", query: { page: "1", limit: "10" }, body: [])

      response = order_products.list(page: 1, limit: 10)
      expect(response.success?).to be true
    end
  end

  describe "#find" do
    it "fetches a single order product" do
      stub_api(:get, "/orders/100/products/1", body: { id: 1, name: "Coffee Beans" })

      response = order_products.find(1)
      expect(response.body[:name]).to eq("Coffee Beans")
    end
  end
end
