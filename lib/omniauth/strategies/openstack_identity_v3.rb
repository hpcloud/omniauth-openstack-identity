require 'omniauth'
require 'keystone_v3'

module OmniAuth
  module Strategies
    class OpenstackIdentityV3

      include OmniAuth::Strategy

      # endpoint ex: http://192.168.27.100:5000/v3
      args [:endpoint]

      option :fields, [:username, :password, :domain_name, :project_name]
      option :uid_field, :username

      def setup
        puts "Entering SETUP phase"
      end

      def request_phase
        puts "Entering REQUEST phase"

        OmniAuth::Form.build(:title => options.title, :url => callback_path) do
          text_field 'Username', 'username'
          password_field 'Password', 'password'
          text_field 'Domain Name', 'domain_name'
          text_field 'Project Name', 'project_name'
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

      def domain_name
        request['domain_name']
      end

      def project_name
        request['project_name']
      end

      def authentication_response
        unless @authentication_response
          return unless username && password && domain_name && project_name

          ks = KeystoneV3.new({
            'url'=>"#{api_uri}",
            'username'=>"#{username}",
            'password'=>"#{password}",
            'domain_name'=>"#{domain_name}",
            'project_name'=>"#{project_name}"
          })

          @authentication_response = ks.authenticate
        end
        @authentication_response
      end

    end
  end
end
