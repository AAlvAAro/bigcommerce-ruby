# frozen_string_literal: true

require_relative "lib/bigcommerce/version"

Gem::Specification.new do |spec|
  spec.name = "bigcommerce-api"
  spec.version = Bigcommerce::VERSION
  spec.authors = ["Alvaro"]
  spec.email = ["aalvaaro@users.noreply.github.com"]

  spec.summary = "Ruby client for the BigCommerce REST Management API"
  spec.description = "A lightweight Ruby wrapper for the BigCommerce V2 Orders API with support for orders, shipments, products, and more."
  spec.homepage = "https://github.com/AAlvAAro/bigcommerce-api"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir["lib/**/*", "LICENSE", "README.md", "CHANGELOG.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.0"
  spec.add_dependency "faraday-retry", "~> 2.0"
end
