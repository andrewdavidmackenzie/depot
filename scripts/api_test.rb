#!/Users/andrew/.rvm/rubies/ruby-2.1.1/bin/ruby
require 'net/http'
require 'json'

# DEFAULT_HOST = 'api.2445581056832.proxy.3scale.net:80'
DEFAULT_HOST = 'api.2445581056832.proxy.3scale.net:80'
PRODUCTS_PATH = '/products.json'
USER_KEY = '596189725924ca31199b71d1fd8534c5'

# /product/1.json for product with id = 1
def product_path(id)
  "/product/#{id}.json"
end

def api_request(uri)
  puts "\nMaking request to: " + uri.to_s + ' with user_key=' + USER_KEY
  # Add user key
  new_query_ar = URI.decode_www_form(uri.query || '') << ['user_key', USER_KEY]
  uri.query = URI.encode_www_form(new_query_ar)

  response = Net::HTTP.get_response(uri)
  if response.code == '200'
    puts 'Response OK'
  else
    raise SystemCallError('Error Code: ' + response.code)
  end
  return response
end

def get_product_list(root_url)
  response = api_request(URI.parse(root_url + PRODUCTS_PATH))
  json = JSON.parse(response.body)
end

def get_hostname
  hostname = DEFAULT_HOST
  puts "Enter hostname (default='#{DEFAULT_HOST}')"
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
begin
  product_list = get_product_list(root_url)
  puts 'Found %d products' % [product_list.size.to_s]
  puts 'Hit enter to repeat, or enter Q to Quit'
  input = gets

rescue SystemCallError
  $stderr.print 'IO failed: ' + $!.to_s

end while input && !input.include?('q')