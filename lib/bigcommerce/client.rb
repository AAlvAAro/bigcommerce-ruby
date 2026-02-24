# frozen_string_literal: true

module Bigcommerce
  class Client
    attr_reader :config, :connection

    def initialize(store_hash: nil, access_token: nil, **options)
      @config = Configuration.new
      @config.store_hash = store_hash || Bigcommerce.configuration.store_hash
      @config.access_token = access_token || Bigcommerce.configuration.access_token
      @config.timeout = options[:timeout] if options[:timeout]
      @config.open_timeout = options[:open_timeout] if options[:open_timeout]
      @config.validate!
      @connection = Connection.new(@config)
    end

    def orders
      @orders ||= Resources::Orders.new(connection)
    end

    def order_products(order_id)
      Resources::OrderProducts.new(connection, order_id)
    end

    def order_shipments(order_id)
      Resources::OrderShipments.new(connection, order_id)
    end

    def order_shipping_addresses(order_id)
      Resources::OrderShippingAddresses.new(connection, order_id)
    end

    def order_coupons(order_id)
      Resources::OrderCoupons.new(connection, order_id)
    end

    def order_taxes(order_id)
      Resources::OrderTaxes.new(connection, order_id)
    end

    def order_messages(order_id)
      Resources::OrderMessages.new(connection, order_id)
    end

    def order_fees(order_id)
      Resources::OrderFees.new(connection, order_id)
    end

    def order_statuses
      @order_statuses ||= Resources::OrderStatuses.new(connection)
    end

    def abandoned_carts
      @abandoned_carts ||= Resources::AbandonedCarts.new(connection)
    end

    def abandoned_cart_settings
      @abandoned_cart_settings ||= Resources::AbandonedCartSettings.new(connection)
    end

    def inventory_items
      @inventory_items ||= Resources::InventoryItems.new(connection)
    end

    def inventory_adjustments
      @inventory_adjustments ||= Resources::InventoryAdjustments.new(connection)
    end
  end
end
