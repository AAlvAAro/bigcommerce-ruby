# frozen_string_literal: true

RSpec.describe Bigcommerce::Client do
  describe "#initialize" do
    it "creates a client with explicit credentials" do
      client = described_class.new(store_hash: "abc123", access_token: "token123")
      expect(client.config.store_hash).to eq("abc123")
      expect(client.config.access_token).to eq("token123")
    end

    it "falls back to global configuration" do
      Bigcommerce.configure do |c|
        c.store_hash = "global_hash"
        c.access_token = "global_token"
      end

      client = described_class.new
      expect(client.config.store_hash).to eq("global_hash")
      expect(client.config.access_token).to eq("global_token")
    end

    it "raises ConfigurationError without store_hash" do
      expect { described_class.new(access_token: "token") }
        .to raise_error(Bigcommerce::ConfigurationError, /store_hash/)
    end

    it "raises ConfigurationError without access_token" do
      expect { described_class.new(store_hash: "hash") }
        .to raise_error(Bigcommerce::ConfigurationError, /access_token/)
    end
  end

  describe "resource accessors" do
    let(:client) { build_client }

    it "returns an Orders resource" do
      expect(client.orders).to be_a(Bigcommerce::Resources::Orders)
    end

    it "returns an OrderProducts resource" do
      expect(client.order_products(1)).to be_a(Bigcommerce::Resources::OrderProducts)
    end

    it "returns an OrderShipments resource" do
      expect(client.order_shipments(1)).to be_a(Bigcommerce::Resources::OrderShipments)
    end

    it "returns an OrderShippingAddresses resource" do
      expect(client.order_shipping_addresses(1)).to be_a(Bigcommerce::Resources::OrderShippingAddresses)
    end

    it "returns an OrderCoupons resource" do
      expect(client.order_coupons(1)).to be_a(Bigcommerce::Resources::OrderCoupons)
    end

    it "returns an OrderStatuses resource" do
      expect(client.order_statuses).to be_a(Bigcommerce::Resources::OrderStatuses)
    end
  end
end
