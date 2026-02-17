# frozen_string_literal: true

RSpec.describe Bigcommerce::Resources::OrderStatuses do
  let(:client) { build_client }
  let(:statuses) { client.order_statuses }

  describe "#list" do
    it "fetches all order statuses" do
      stub_api(:get, "/order_statuses", body: [
        { id: 1, name: "Pending", system_label: "Pending" },
        { id: 2, name: "Shipped", system_label: "Shipped" }
      ])

      response = statuses.list
      expect(response.body.length).to eq(2)
      expect(response.body.first[:name]).to eq("Pending")
    end
  end

  describe "#find" do
    it "fetches a single order status" do
      stub_api(:get, "/order_statuses/1", body: { id: 1, name: "Pending" })

      response = statuses.find(1)
      expect(response.body[:name]).to eq("Pending")
    end
  end
end
