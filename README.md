# BigCommerce API

A lightweight Ruby client for the BigCommerce REST Management API (V2 Orders).

## Installation

Add to your Gemfile:

```ruby
gem "bigcommerce-api"
```

Or install directly:

```
gem install bigcommerce-api
```

## Configuration

### Global configuration

```ruby
Bigcommerce.configure do |config|
  config.store_hash   = ENV["BIGCOMMERCE_STORE_HASH"]
  config.access_token = ENV["BIGCOMMERCE_ACCESS_TOKEN"]
  config.timeout      = 30  # optional, default: 30s
  config.open_timeout = 10  # optional, default: 10s
end

client = Bigcommerce.client
```

### Per-client configuration

```ruby
client = Bigcommerce::Client.new(
  store_hash: "your_store_hash",
  access_token: "your_access_token"
)
```

## Usage

### Orders

```ruby
# List orders (with filtering and pagination)
client.orders.list(page: 1, limit: 25)
client.orders.list(status_id: 11, min_date_created: "2025-01-01")
client.orders.list(sort: "date_created", customer_id: 42)

# Get a single order
client.orders.find(100)

# Create an order
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

# Update an order
client.orders.update(100, status_id: 2, staff_notes: "Shipped today")

# Archive an order
client.orders.archive(100)

# Get order count
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

## Response Object

All methods return a `Bigcommerce::Response` with:

```ruby
response = client.orders.list

response.body       # Parsed JSON (Hash/Array with symbol keys)
response.status     # HTTP status code
response.headers    # Response headers
response.success?   # true for 2xx responses
response.rate_limit       # Remaining API calls
response.rate_limit_reset # Reset time in ms
```

## Error Handling

```ruby
begin
  client.orders.find(999)
rescue Bigcommerce::NotFoundError => e
  puts "Order not found"
rescue Bigcommerce::AuthenticationError => e
  puts "Bad credentials"
rescue Bigcommerce::RateLimitError => e
  puts "Rate limited, retry after #{e.response.rate_limit_reset}ms"
rescue Bigcommerce::UnprocessableEntityError => e
  puts "Validation error: #{e.message}"
rescue Bigcommerce::ServerError => e
  puts "BigCommerce server error"
rescue Bigcommerce::ApiError => e
  puts "API error #{e.status}: #{e.message}"
end
```

Built-in retry with exponential backoff handles 429 and 5xx responses automatically (3 retries).

## Development

```
bundle install
bundle exec rspec
```

## License

MIT
