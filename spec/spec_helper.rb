# frozen_string_literal: true

require "webmock/rspec"
require "bigcommerce"

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.order = :random

  config.before do
    Bigcommerce.reset!
  end
end

STORE_HASH = "test_store"
ACCESS_TOKEN = "test_token"
BASE_URL_V2 = "https://api.bigcommerce.com/stores/#{STORE_HASH}/v2"
BASE_URL_V3 = "https://api.bigcommerce.com/stores/#{STORE_HASH}/v3"
BASE_URL = BASE_URL_V2

def stub_api(method, path, status: 200, body: nil, query: nil, api_version: :v2)
  base = api_version == :v3 ? BASE_URL_V3 : BASE_URL_V2
  stub = stub_request(method, "#{base}#{path}")
  stub = stub.with(query: query) if query
  stub.to_return(
    status: status,
    body: body&.to_json,
    headers: { "Content-Type" => "application/json" }
  )
end

def build_client
  Bigcommerce::Client.new(store_hash: STORE_HASH, access_token: ACCESS_TOKEN)
end
