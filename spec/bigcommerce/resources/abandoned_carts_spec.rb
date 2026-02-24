# frozen_string_literal: true

RSpec.describe Bigcommerce::Resources::AbandonedCarts do
  let(:client) { build_client }
  let(:abandoned_carts) { client.abandoned_carts }

  describe "#find" do
    let(:token) { "a7e38a5b-4f68-4e8b-9b2c-1234567890ab" }

    it "fetches a cart_id by abandoned cart token" do
      stub_api(:get, "/abandoned-carts/#{token}",
               api_version: :v3,
               body: { data: { cart_id: "bc218c65-7a32-4ab7-8082-68b56f744f" }, meta: {} })

      response = abandoned_carts.find(token)
      expect(response.body[:data][:cart_id]).to eq("bc218c65-7a32-4ab7-8082-68b56f744f")
    end

    it "raises NotFoundError for invalid token" do
      stub_api(:get, "/abandoned-carts/#{token}",
               api_version: :v3,
               status: 404,
               body: { title: "Not Found" })

      expect { abandoned_carts.find(token) }.to raise_error(Bigcommerce::NotFoundError)
    end
  end
end
