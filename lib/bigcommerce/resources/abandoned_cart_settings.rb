# frozen_string_literal: true

module Bigcommerce
  module Resources
    class AbandonedCartSettings < Resource
      # GET /abandoned-carts/settings
      # Get global abandoned cart settings.
      # @return [Bigcommerce::Response]
      def get_global
        get("/abandoned-carts/settings")
      end

      # PUT /abandoned-carts/settings
      # Update global abandoned cart settings.
      # @param attributes [Hash] Settings attributes
      # @option attributes [Boolean] :enable_notification Enable abandoned cart notifications
      # @option attributes [Boolean] :email_customer_until_cart_is_recovered Email customer until cart is recovered
      # @option attributes [Boolean] :marketing_emails_require_customer_consent Require customer consent for marketing emails
      # @option attributes [Boolean] :email_merchant_when_cart_is_converted Email merchant when cart is converted
      # @option attributes [Boolean] :email_merchant_when_cart_is_abandoned Email merchant when cart is abandoned
      # @option attributes [String] :merchant_email_address Merchant email address
      # @option attributes [String] :merchant_abandoned_cart_email_frequency_type Frequency type ("digest" or "individual")
      # @option attributes [Integer] :merchant_abandoned_cart_digest_email_frequency Digest frequency (2-1000)
      # @return [Bigcommerce::Response]
      def update_global(**attributes)
        put("/abandoned-carts/settings", attributes)
      end

      # GET /abandoned-carts/settings/channels/:channel_id
      # Get channel-specific abandoned cart settings.
      # @param channel_id [Integer] Channel ID
      # @return [Bigcommerce::Response]
      def get_channel(channel_id)
        get("/abandoned-carts/settings/channels/#{channel_id}")
      end

      # PUT /abandoned-carts/settings/channels/:channel_id
      # Update channel-specific abandoned cart settings.
      # All fields are nullable — set to nil to inherit from global settings.
      # @param channel_id [Integer] Channel ID
      # @param attributes [Hash] Settings attributes (same as global, but all nullable)
      # @return [Bigcommerce::Response]
      def update_channel(channel_id, **attributes)
        put("/abandoned-carts/settings/channels/#{channel_id}", attributes)
      end

      private

      def api_version
        :v3
      end
    end
  end
end
