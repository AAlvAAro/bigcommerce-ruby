# frozen_string_literal: true

RSpec.describe Bigcommerce::Connection do
  let(:config) do
    Bigcommerce::Configuration.new.tap do |c|
      c.store_hash = STORE_HASH
      c.access_token = ACCESS_TOKEN
    end
  end
  let(:connection) { described_class.new(config) }

  describe "authentication" do
    it "sends X-Auth-Token header" do
      stub = stub_request(:get, "#{BASE_URL}/orders")
        .with(headers: { "X-Auth-Token" => ACCESS_TOKEN })
        .to_return(status: 200, body: "[]", headers: { "Content-Type" => "application/json" })

      connection.get("/orders")
      expect(stub).to have_been_requested
    end
  end

  describe "error handling" do
    it "raises AuthenticationError on 401" do
      stub_api(:get, "/orders", status: 401, body: { message: "Unauthorized" })
      expect { connection.get("/orders") }.to raise_error(Bigcommerce::AuthenticationError)
    end

    it "raises NotFoundError on 404" do
      stub_api(:get, "/orders/999", status: 404, body: { message: "Not found" })
      expect { connection.get("/orders/999") }.to raise_error(Bigcommerce::NotFoundError)
    end

    it "raises UnprocessableEntityError on 422" do
      stub_api(:post, "/orders", status: 422, body: { title: "Invalid data" })
      expect { connection.post("/orders", {}) }.to raise_error(Bigcommerce::UnprocessableEntityError)
    end

    it "raises ServerError on 500" do
      stub_api(:get, "/orders", status: 500, body: { message: "Internal error" })
      expect { connection.get("/orders") }.to raise_error(Bigcommerce::ServerError)
    end

    it "raises RateLimitError on 429" do
      stub_request(:get, "#{BASE_URL}/orders")
        .to_return(
          status: 429,
          body: { message: "Rate limit" }.to_json,
          headers: { "Content-Type" => "application/json", "x-rate-limit-time-reset-ms" => "100" }
        ).then
        .to_return(
          status: 429,
          body: { message: "Rate limit" }.to_json,
          headers: { "Content-Type" => "application/json", "x-rate-limit-time-reset-ms" => "100" }
        ).then
        .to_return(
          status: 429,
          body: { message: "Rate limit" }.to_json,
          headers: { "Content-Type" => "application/json", "x-rate-limit-time-reset-ms" => "100" }
        ).then
        .to_return(
          status: 429,
          body: { message: "Rate limit" }.to_json,
          headers: { "Content-Type" => "application/json", "x-rate-limit-time-reset-ms" => "100" }
        )

      expect { connection.get("/orders") }.to raise_error(Bigcommerce::RateLimitError)
    end
  end

  describe "successful responses" do
    it "returns a Response object" do
      stub_api(:get, "/orders", body: [{ id: 1 }])
      response = connection.get("/orders")
      expect(response).to be_a(Bigcommerce::Response)
      expect(response.body).to eq([{ id: 1 }])
    end

    it "handles 204 No Content" do
      stub_api(:delete, "/orders/1", status: 204)
      response = connection.delete("/orders/1")
      expect(response.success?).to be true
    end
  end
end
