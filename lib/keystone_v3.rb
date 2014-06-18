require 'faraday'
require 'faraday_middleware'

class KeystoneV3

  def initialize(options={})
    @url = options['url']
    @username = options['username']
    @password = options['password']
    @domain_name = options['domain_name']
    @project_name = options['project_name']

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
    resp = @conn.post 'auth/tokens' do |request|
      request.body = {
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
                      }
                  }
              },
              "scope" => {
                  "project" => {
                      "domain" => {
                          "name" => "#{@domain_name}"
                      },
                      "name" => "#{@project_name}"
                  }
              }
          }
      }
    end # post
    resp.body
  end # authenticate

end # class
