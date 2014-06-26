require 'omniauth'
require 'keystone/keystone_v2'

module OmniAuth
  module Strategies
    class OpenstackIdentityV2

      include OmniAuth::Strategy

      # endpoint ex: http://10.10.10.10:5000/v2.0
      args [:endpoint]

      option :fields, [:username, :password]
      option :uid_field, :username

      attr_reader :auth_token


      def request_phase
        if env["REQUEST_METHOD"] == "GET"
          get_credentials
        else
          auth_via_params(callback_path)
        end
      end

      def callback_phase
        perform_authenticate
        return fail!(:invalid_credentials) unless @authentication_response
        return fail!(:invalid_credentials) if @authentication_response.status.to_i >= 400
        super
      end


      uid do
        request.params[options.uid_field.to_s]
      end

      info do
        options.fields.inject({}) do |hash, field|
          hash[field] = request.params[field.to_s]
          hash
        end
      end

      credentials do
        {'token' => @auth_token, 'username' => username, 'secret' => password}
      end

      extra do
        {'raw_info' => @authentication_response}
      end


      protected

      # by default we use static uri. If dynamic uri is required, override
      # this method.
      def api_uri
        options.endpoint
      end

      def username
        request['username']
      end

      def password
        request['password']
      end

      def perform_authenticate
        unless @authentication_response
          return unless username && password

          ks = ::Keystone::KeystoneV2.new({
            'url'=>"#{api_uri}",
            'username'=>"#{username}",
            'password'=>"#{password}"})

          @authentication_response = ks.authenticate
          @auth_token = extract_auth_token(@authentication_response)
        end

        @authentication_response
      end

      private

      def get_credentials
        options.title = "Keystone v2 auth: username+password"
        OmniAuth::Form.build(:title => options.title, :url => callback_path) do
          text_field 'Username', 'username'
          password_field 'Password', 'password'
        end.to_response
      end

      def auth_via_params(callback_path)
        redirect(callback_path)
      rescue ::Timeout::Error => e
        fail!(:timeout, e)
      rescue ::Net::HTTPFatalError => e
        fail!(:service_unavailable, e)
      end

      def extract_auth_token(faraday_response)
        body = faraday_response.body
        body['access']['token']['id']
      end
    end
  end
end
