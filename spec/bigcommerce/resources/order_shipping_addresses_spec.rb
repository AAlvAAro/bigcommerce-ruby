# frozen_string_literal: true

RSpec.describe Bigcommerce::Resources::OrderShippingAddresses do
  let(:client) { build_client }
  let(:addresses) { client.order_shipping_addresses(100) }

  describe "#list" do
    it "fetches shipping addresses for an order" do
      stub_api(:get, "/orders/100/shipping_addresses", body: [
        { id: 1, first_name: "John", city: "Austin" }
      ])

      response = addresses.list
      expect(response.body.first[:city]).to eq("Austin")
    end
  end

  describe "#find" do
    it "fetches a single shipping address" do
      stub_api(:get, "/orders/100/shipping_addresses/1", body: { id: 1, city: "Austin" })

      response = addresses.find(1)
      expect(response.body[:city]).to eq("Austin")
    end
  end

  describe "#update" do
    it "updates a shipping address" do
      stub_api(:put, "/orders/100/shipping_addresses/1", body: { id: 1, city: "Dallas" })

      response = addresses.update(1, city: "Dallas")
      expect(response.body[:city]).to eq("Dallas")
    end
  end
end
