# frozen_string_literal: true

RSpec.describe Bigcommerce::Resources::Orders do
  let(:client) { build_client }
  let(:orders) { client.orders }

  describe "#list" do
    it "fetches all orders" do
      stub_api(:get, "/orders", body: [{ id: 1 }, { id: 2 }])

      response = orders.list
      expect(response.body.length).to eq(2)
      expect(response.body.first[:id]).to eq(1)
    end

    it "supports filtering by status_id" do
      stub_api(:get, "/orders", query: { status_id: "11" }, body: [{ id: 1 }])

      response = orders.list(status_id: 11)
      expect(response.body.length).to eq(1)
    end

    it "supports pagination" do
      stub_api(:get, "/orders", query: { page: "2", limit: "10" }, body: [])

      response = orders.list(page: 2, limit: 10)
      expect(response.success?).to be true
    end

    it "supports date range filtering" do
      stub_api(:get, "/orders",
               query: { min_date_created: "2025-01-01", max_date_created: "2025-12-31" },
               body: [{ id: 1 }])

      response = orders.list(min_date_created: "2025-01-01", max_date_created: "2025-12-31")
      expect(response.success?).to be true
    end

    it "supports sorting" do
      stub_api(:get, "/orders", query: { sort: "date_created" }, body: [])

      response = orders.list(sort: "date_created")
      expect(response.success?).to be true
    end
  end

  describe "#find" do
    it "fetches a single order" do
      stub_api(:get, "/orders/100", body: { id: 100, status: "Pending" })

      response = orders.find(100)
      expect(response.body[:id]).to eq(100)
      expect(response.body[:status]).to eq("Pending")
    end

    it "raises NotFoundError for non-existent order" do
      stub_api(:get, "/orders/999", status: 404, body: { message: "Not found" })

      expect { orders.find(999) }.to raise_error(Bigcommerce::NotFoundError)
    end
  end

  describe "#create" do
    let(:order_data) do
      {
        customer_id: 1,
        billing_address: {
          first_name: "John",
          last_name: "Doe",
          street_1: "123 Main St",
          city: "Austin",
          state: "TX",
          zip: "78701",
          country: "United States",
          country_iso2: "US",
          email: "john@example.com"
        },
        products: [
          { product_id: 10, quantity: 2 }
        ]
      }
    end

    it "creates an order" do
      stub_api(:post, "/orders", body: { id: 200, status_id: 1 })

      response = orders.create(**order_data)
      expect(response.body[:id]).to eq(200)
    end
  end

  describe "#update" do
    it "updates an order" do
      stub_api(:put, "/orders/100", body: { id: 100, status_id: 2 })

      response = orders.update(100, status_id: 2)
      expect(response.body[:status_id]).to eq(2)
    end
  end

  describe "#archive" do
    it "archives an order" do
      stub_api(:delete, "/orders/100", status: 204)

      response = orders.archive(100)
      expect(response.success?).to be true
    end
  end

  describe "#count" do
    it "returns the order count" do
      stub_api(:get, "/orders/count", body: { count: 42 })

      response = orders.count
      expect(response.body[:count]).to eq(42)
    end

    it "supports filtering" do
      stub_api(:get, "/orders/count", query: { status_id: "11" }, body: { count: 5 })

      response = orders.count(status_id: 11)
      expect(response.body[:count]).to eq(5)
    end
  end
end
