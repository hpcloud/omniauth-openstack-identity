require 'omniauth'
require 'keystone_v2'

module OmniAuth
  module Strategies
    class OpenstackIdentityV2

      include OmniAuth::Strategy

      # endpoint ex: http://10.10.10.10:5000/v2.0
      args [:endpoint]

      option :fields, [:username, :password, :tenant_name]
      option :uid_field, :username


      def request_phase
        if env["REQUEST_METHOD"] == "GET"
          get_credentials
        else
          auth_via_params(callback_path)
        end
      end

      def callback_phase
        return fail!(:invalid_credentials) unless authentication_response
        # return fail!(:invalid_credentials) if authentication_response.code.to_i >= 400
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
        {'token' => username, 'secret' => password}
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

      def tenant_name
        request['tenant_name']
      end

      def authentication_response
        unless @authentication_response
          return unless username && password && tenant_name

          ks = KeystoneV2.new({
            'url'=>"#{api_uri}",
            'username'=>"#{username}",
            'password'=>"#{password}",
            'tenant_name'=>"#{tenant_name}"})

          @authentication_response = ks.authenticate
        end

        @authentication_response
      end

      private

      def get_credentials
        OmniAuth::Form.build(:title => options.title, :url => callback_path) do
          text_field 'Tenant Name', 'tenant_name'
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
    end
  end
end
