# frozen_string_literal: true

module Bigcommerce
  module Resources
    class OrderMessages < Resource
      def initialize(connection, order_id)
        super(connection)
        @order_id = order_id
      end

      # GET /orders/:order_id/messages
      # @param params [Hash] Query parameters
      # @option params [Integer] :min_id Minimum message ID
      # @option params [Integer] :max_id Maximum message ID
      # @option params [Integer] :customer_id Filter by customer ID
      # @option params [String] :min_date_created Minimum date created
      # @option params [String] :max_date_created Maximum date created
      # @option params [Boolean] :is_flagged Filter by flagged status
      # @option params [String] :status Filter by status (read, unread)
      # @option params [Integer] :page Page number (default: 1)
      # @option params [Integer] :limit Results per page (default: 50)
      # @return [Bigcommerce::Response]
      def list(**params)
        get("/orders/#{@order_id}/messages", params)
      end
    end
  end
end
