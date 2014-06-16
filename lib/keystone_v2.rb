require 'faraday'
require 'faraday_middleware'

class KeystoneV2

  def initialize(options={})
    @url = options['url']
    @username = options['username']
    @password = options['password']
    @tenant_name = options['tenant_name']

    @conn = Faraday.new(:url => @url) do |faraday|
      faraday.use FaradayMiddleware::ParseJson, content_type: 'application/json'
      faraday.request  :json
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.response :raise_error
      faraday.response :json, :content_type => "application/json"
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end # new
  end # initialize

  def authenticate
    resp = @conn.post 'tokens' do |request|
      request.body = {
         "auth" => {
            "tenantName" => "#{@tenant_name}",
            "passwordCredentials" => {
               "username" => "#{@username}",
               "password" => "#{@password}"
            }
         }
      }
    end # post
    resp.body
  end # authenticate

end # class
