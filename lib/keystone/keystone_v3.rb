require 'faraday'
require 'faraday_middleware'

module Keystone
  class KeystoneV3

    def initialize(options={})

      @url = options['url']
      @username = options['username']
      @password = options['password']
      @domain_name = options['domain_name']

      build_connection
    end

    def authenticate
      resp = @conn.post 'auth/tokens' do |request|
        request.body = auth_hash
      end
      resp
    end


    private

    def build_connection
      @conn = Faraday.new(:url => @url) do |faraday|
        faraday.use FaradayMiddleware::ParseJson, content_type: 'application/json'
        faraday.request  :json
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.response :raise_error
        faraday.response :json, :content_type => "application/json"
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def auth_hash
      {
        "auth" => {
            "identity" => {
                "methods" => [
                    "password"
                ],
                "password" => {
                    "user" => {
                        "domain" => {
                            "name" => "#{@domain_name}"
                        },
                        "name" => "#{@username}",
                        "password" => "#{@password}"
                    } # user
                } #password
            } # identity
        } # auth
      }
    end

  end

end
