# frozen_string_literal: true

require_relative "bigcommerce/version"
require_relative "bigcommerce/configuration"
require_relative "bigcommerce/errors"
require_relative "bigcommerce/response"
require_relative "bigcommerce/connection"
require_relative "bigcommerce/resource"
require_relative "bigcommerce/client"
require_relative "bigcommerce/resources/orders"
require_relative "bigcommerce/resources/order_products"
require_relative "bigcommerce/resources/order_shipments"
require_relative "bigcommerce/resources/order_shipping_addresses"
require_relative "bigcommerce/resources/order_coupons"
require_relative "bigcommerce/resources/order_taxes"
require_relative "bigcommerce/resources/order_messages"
require_relative "bigcommerce/resources/order_fees"
require_relative "bigcommerce/resources/order_statuses"

module Bigcommerce
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def client(**options)
      Client.new(**options)
    end

    def reset!
      @configuration = Configuration.new
    end
  end
end
