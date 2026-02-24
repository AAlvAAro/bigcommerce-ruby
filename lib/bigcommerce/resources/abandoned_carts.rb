# frozen_string_literal: true

module Bigcommerce
  module Resources
    class AbandonedCarts < Resource
      # GET /abandoned-carts/:token
      # Returns the cart_id for a given abandoned cart token.
      # The token is the UUID found in the query string of abandoned cart email links.
      # @param token [String] Abandoned cart UUID token
      # @return [Bigcommerce::Response]
      def find(token)
        get("/abandoned-carts/#{token}")
      end

      private

      def api_version
        :v3
      end
    end
  end
end
