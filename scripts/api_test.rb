#!/Users/andrew/.rvm/rubies/ruby-2.1.1/bin/ruby
require 'net/http'
require 'json'

PRODUCTS_PATH = '/products.json'
PRODUCT_PATH = '/product/#{id}.json' # /product/1.json for product with id = 1

def product_path(id)
  path = PRODUCT_PATH
end

def api_request(uri)
  puts "\nMaking request to: " + uri.to_s
  response = Net::HTTP.get_response(uri)
  puts 'Response OK' if response.code == '200'
  return response
end

def get_product_list(root_url)
  response = api_request(URI.parse(root_url + PRODUCTS_PATH))
  json = JSON.parse(response.body)
end

def get_hostname
  hostname = '0.0.0.0:3000'
  puts 'Enter hostname (default="0.0.0.0:3000")'
  STDOUT.flush
  input = gets.chomp
  hostname = input unless input.empty?
  return hostname
end

root_url = 'http://' + get_hostname
puts 'Using root Url: ' + root_url

# GET /products.json
# GET /products/1.json
# POST /products.json
# PATCH/PUT /products/1.json
# DELETE /products/1.json

# Get the list of products
product_list = get_product_list(root_url)
puts "Found %d products" % [product_list.size.to_s]