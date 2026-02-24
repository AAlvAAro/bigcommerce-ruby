# bigcommerce-ruby

[![Gem Version](https://badge.fury.io/rb/bigcommerce-ruby.svg)](https://rubygems.org/gems/bigcommerce-ruby)

A Ruby gem for the BigCommerce REST Management API. Thin, idiomatic, and built on Faraday — no magic, just clean API access with automatic retries and proper error handling.

## Installation

```ruby
# Gemfile
gem "bigcommerce-ruby"
```

```
gem install bigcommerce-ruby
```

## Configuration

**Global** (recommended for Rails apps):

```ruby
Bigcommerce.configure do |config|
  config.store_hash   = ENV["BIGCOMMERCE_STORE_HASH"]
  config.access_token = ENV["BIGCOMMERCE_ACCESS_TOKEN"]
  config.timeout      = 30  # optional, default: 30s
  config.open_timeout = 10  # optional, default: 10s
end

client = Bigcommerce.client
```

**Per-client** (useful for multi-tenant apps):

```ruby
client = Bigcommerce::Client.new(
  store_hash: "your_store_hash",
  access_token: "your_access_token"
)
```

## Usage

### Orders

```ruby
# List with filtering, sorting, and pagination
client.orders.list(page: 1, limit: 25)
client.orders.list(status_id: 11, min_date_created: "2025-01-01")
client.orders.list(sort: "date_created", direction: "desc", customer_id: 42)

# Single order
client.orders.find(100)

# Create
client.orders.create(
  customer_id: 1,
  billing_address: {
    first_name: "John",
    last_name: "Doe",
    street_1: "123 Main St",
    city: "Austin",
    state: "TX",
    zip: "78701",
    country: "United States",
    country_iso2: "US",
    email: "john@example.com"
  },
  products: [
    { product_id: 10, quantity: 2 }
  ]
)

# Update
client.orders.update(100, status_id: 2, staff_notes: "Shipped today")

# Archive
client.orders.archive(100)

# Count
client.orders.count
client.orders.count(status_id: 11)
```

### Order Products

```ruby
products = client.order_products(100)

products.list
products.list(page: 1, limit: 10)
products.find(5)
```

### Order Shipments

```ruby
shipments = client.order_shipments(100)

shipments.list
shipments.find(1)
shipments.count

shipments.create(
  order_address_id: 1,
  items: [{ order_product_id: 10, quantity: 1 }],
  tracking_number: "ABC123",
  shipping_provider: "usps"
)

shipments.update(1, tracking_number: "XYZ789")
shipments.destroy(1)
shipments.destroy_all
```

### Order Shipping Addresses

```ruby
addresses = client.order_shipping_addresses(100)

addresses.list
addresses.find(1)
addresses.update(1, city: "Dallas", state: "TX")
```

### Order Coupons

```ruby
client.order_coupons(100).list
```

### Order Taxes

```ruby
client.order_taxes(100).list
client.order_taxes(100).list(details: "true")
```

### Order Messages

```ruby
messages = client.order_messages(100)
messages.list
messages.list(status: "unread", is_flagged: true)
```

### Order Fees

```ruby
client.order_fees(100).list
```

### Order Statuses

```ruby
client.order_statuses.list
client.order_statuses.find(1)
```

## Response

Every method returns a `Bigcommerce::Response`:

```ruby
response = client.orders.list

response.body             # Parsed JSON — Hash or Array with symbol keys
response.status           # HTTP status code
response.headers          # Response headers
response.success?         # true for 2xx
response.rate_limit       # Remaining API calls
response.rate_limit_reset # Time until reset (ms)
```

## Error Handling

Errors map directly to HTTP status codes:

```ruby
begin
  client.orders.find(999)
rescue Bigcommerce::NotFoundError
  puts "Order not found"
rescue Bigcommerce::AuthenticationError
  puts "Bad credentials — check your access token"
rescue Bigcommerce::RateLimitError => e
  puts "Rate limited, retry after #{e.response.rate_limit_reset}ms"
rescue Bigcommerce::UnprocessableEntityError => e
  puts "Validation error: #{e.message}"
rescue Bigcommerce::ServerError
  puts "BigCommerce server error"
rescue Bigcommerce::ApiError => e
  puts "API error #{e.status}: #{e.message}"
end
```

| Error class | HTTP status |
|---|---|
| `AuthenticationError` | 401 |
| `NotFoundError` | 404 |
| `UnprocessableEntityError` | 422 |
| `RateLimitError` | 429 |
| `ServerError` | 5xx |
| `ApiError` | anything else |

Requests that hit 429 or 5xx are automatically retried up to 3 times with exponential backoff. On a 429, the gem reads the `x-rate-limit-time-reset-ms` header and sleeps accordingly before retrying.

## Development

```
bundle install
bundle exec rspec
```

## License

MIT
