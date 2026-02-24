# frozen_string_literal: true

RSpec.describe Bigcommerce::Resources::AbandonedCartSettings do
  let(:client) { build_client }
  let(:settings) { client.abandoned_cart_settings }

  let(:global_settings_response) do
    {
      data: {
        enable_notification: true,
        email_customer_until_cart_is_recovered: true,
        marketing_emails_require_customer_consent: false,
        email_merchant_when_cart_is_converted: true,
        email_merchant_when_cart_is_abandoned: false,
        merchant_email_address: "merchant@example.com",
        merchant_abandoned_cart_email_frequency_type: "digest",
        merchant_abandoned_cart_digest_email_frequency: 24
      },
      meta: {}
    }
  end

  describe "#get_global" do
    it "fetches global abandoned cart settings" do
      stub_api(:get, "/abandoned-carts/settings",
               api_version: :v3,
               body: global_settings_response)

      response = settings.get_global
      expect(response.body[:data][:enable_notification]).to be true
      expect(response.body[:data][:merchant_email_address]).to eq("merchant@example.com")
    end
  end

  describe "#update_global" do
    it "updates global abandoned cart settings" do
      stub_api(:put, "/abandoned-carts/settings",
               api_version: :v3,
               body: global_settings_response.merge(
                 data: global_settings_response[:data].merge(enable_notification: false)
               ))

      response = settings.update_global(
        enable_notification: false,
        email_customer_until_cart_is_recovered: true,
        marketing_emails_require_customer_consent: false,
        email_merchant_when_cart_is_converted: true,
        email_merchant_when_cart_is_abandoned: false,
        merchant_email_address: "merchant@example.com",
        merchant_abandoned_cart_email_frequency_type: "digest",
        merchant_abandoned_cart_digest_email_frequency: 24
      )
      expect(response.body[:data][:enable_notification]).to be false
    end
  end

  describe "#get_channel" do
    it "fetches channel-specific abandoned cart settings" do
      stub_api(:get, "/abandoned-carts/settings/channels/1",
               api_version: :v3,
               body: {
                 data: {
                   enable_notification: nil,
                   email_customer_until_cart_is_recovered: nil,
                   marketing_emails_require_customer_consent: nil,
                   email_merchant_when_cart_is_converted: nil,
                   email_merchant_when_cart_is_abandoned: nil,
                   merchant_email_address: nil,
                   merchant_abandoned_cart_email_frequency_type: nil,
                   merchant_abandoned_cart_digest_email_frequency: nil
                 },
                 meta: {}
               })

      response = settings.get_channel(1)
      expect(response.success?).to be true
      expect(response.body[:data][:enable_notification]).to be_nil
    end
  end

  describe "#update_channel" do
    it "updates channel-specific abandoned cart settings" do
      stub_api(:put, "/abandoned-carts/settings/channels/1",
               api_version: :v3,
               body: {
                 data: {
                   enable_notification: true,
                   email_customer_until_cart_is_recovered: nil,
                   marketing_emails_require_customer_consent: nil,
                   email_merchant_when_cart_is_converted: nil,
                   email_merchant_when_cart_is_abandoned: nil,
                   merchant_email_address: "channel@example.com",
                   merchant_abandoned_cart_email_frequency_type: nil,
                   merchant_abandoned_cart_digest_email_frequency: nil
                 },
                 meta: {}
               })

      response = settings.update_channel(1,
        enable_notification: true,
        merchant_email_address: "channel@example.com")
      expect(response.body[:data][:enable_notification]).to be true
      expect(response.body[:data][:merchant_email_address]).to eq("channel@example.com")
    end
  end
end
