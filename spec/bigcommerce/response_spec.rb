# frozen_string_literal: true

RSpec.describe Bigcommerce::Response do
  let(:faraday_response) do
    instance_double(
      Faraday::Response,
      status: 200,
      headers: {
        "Content-Type" => "application/json",
        "x-rate-limit-requests-left" => "150",
        "x-rate-limit-time-reset-ms" => "15000"
      },
      body: '{"id":1,"name":"Test"}'
    )
  end

  subject(:response) { described_class.new(faraday_response) }

  describe "#success?" do
    it "returns true for 2xx status" do
      expect(response.success?).to be true
    end
  end

  describe "#body" do
    it "parses JSON body with symbolized keys" do
      expect(response.body).to eq({ id: 1, name: "Test" })
    end
  end

  describe "#rate_limit" do
    it "returns remaining rate limit" do
      expect(response.rate_limit).to eq(150)
    end
  end

  describe "#rate_limit_reset" do
    it "returns reset time in ms" do
      expect(response.rate_limit_reset).to eq(15_000)
    end
  end

  context "with empty body" do
    let(:faraday_response) do
      instance_double(Faraday::Response, status: 204, headers: {}, body: "")
    end

    it "returns nil for empty body" do
      expect(response.body).to be_nil
    end
  end
end
