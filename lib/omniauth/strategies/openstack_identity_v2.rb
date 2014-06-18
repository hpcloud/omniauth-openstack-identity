require 'omniauth'
require 'keystone_v2'

module OmniAuth
  module Strategies
    class OpenstackIdentityV2

      include OmniAuth::Strategy

      # endpoint ex: http://192.168.27.100:5000/v2.0
      args [:endpoint, :version]

      option :fields, [:username, :password, :tenant_name]
      option :uid_field, :username

      def setup
        puts "Entering SETUP phase"
      end

      def request_phase
        puts "Entering REQUEST phase"

        OmniAuth::Form.build(:title => options.title, :url => callback_path) do
          text_field 'Tenant Name', 'tenant_name'
          text_field 'Username', 'username'
          password_field 'Password', 'password'
        end.to_response
      end

      # def authorize_params
      #   puts "Entering AUTHORIZE phase"
      #   puts request.params
      # end

      # uid do
      #   request.params[options.uid_field.to_s]
      # end
      #
      # info do
      #   options.fields.inject({}) do |hash, field|
      #     hash[field] = request.params[field.to_s]
      #     hash
      #   end
      # end

      def callback_phase
        puts "Entering CALLBACK phase"

        puts " "
        # puts "STATUS:"
        # puts authentication_response.status
        puts "RESPONSE:"
        puts authentication_response.to_yaml
        puts " "

        return fail!(:invalid_credentials) if !authentication_response
        # return fail!(:invalid_credentials) if authentication_response.code.to_i >= 400
        super

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

    end
  end
end
