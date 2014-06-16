require 'omniauth'

module OmniAuth
  module Strategies
    class OpenstackIdentity
      include OmniAuth::Strategy

      # option :name, "openstack_identity"
      option :fields, [:username, :password]
      option :uid_field, :username
      # option :domain, nil

      # def get_identifier
      #   f = OmniAuth::Form.new(:title => 'Google Apps Authentication')
      #   f.label_field('Google Apps Domain', 'domain')
      #   f.input_field('url', 'domain')
      #   f.to_response
      # end

      # def identifier
      #   options[:domain] || request['domain']
      # end
      
      def request_phase
      end

      def callback_phase
      end

    end
  end
end
