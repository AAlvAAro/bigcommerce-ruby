# frozen_string_literal: true

RSpec.describe Bigcommerce::Resources::OrderShipments do
  let(:client) { build_client }
  let(:shipments) { client.order_shipments(100) }

  describe "#list" do
    it "fetches shipments for an order" do
      stub_api(:get, "/orders/100/shipments", body: [{ id: 1, tracking_number: "ABC123" }])

      response = shipments.list
      expect(response.body.first[:tracking_number]).to eq("ABC123")
    end
  end

  describe "#find" do
    it "fetches a single shipment" do
      stub_api(:get, "/orders/100/shipments/1", body: { id: 1 })

      response = shipments.find(1)
      expect(response.body[:id]).to eq(1)
    end
  end

  describe "#create" do
    it "creates a shipment" do
      stub_api(:post, "/orders/100/shipments", body: { id: 5, tracking_number: "XYZ789" })

      response = shipments.create(
        order_address_id: 1,
        items: [{ order_product_id: 10, quantity: 1 }],
        tracking_number: "XYZ789"
      )
      expect(response.body[:tracking_number]).to eq("XYZ789")
    end
  end

  describe "#update" do
    it "updates a shipment" do
      stub_api(:put, "/orders/100/shipments/1", body: { id: 1, tracking_number: "UPDATED" })

      response = shipments.update(1, tracking_number: "UPDATED")
      expect(response.body[:tracking_number]).to eq("UPDATED")
    end
  end

  describe "#destroy" do
    it "deletes a shipment" do
      stub_api(:delete, "/orders/100/shipments/1", status: 204)

      response = shipments.destroy(1)
      expect(response.success?).to be true
    end
  end

  describe "#count" do
    it "returns the shipment count" do
      stub_api(:get, "/orders/100/shipments/count", body: { count: 3 })

      response = shipments.count
      expect(response.body[:count]).to eq(3)
    end
  end
end
