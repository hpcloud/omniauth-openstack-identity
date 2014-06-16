require 'omniauth'

module OmniAuth::Strategies::OpenstackIdentity
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
    puts "AUTHORIZE PARAMS"
    puts authorize_params
    puts "PARAMS"
    puts request.params
    super
  end

  def authorize_params
    super.tap do |params|
      if request.params['scope']
        params[:scope] = request.params['scope']
      end
    end
  end

  # def request_phase
  #   response = Rack::Response.new
  #   response.redirect "#{options.authentication_url}?redir=#{full_host + script_name + callback_path}"
  #   response.finish
  # end

  def callback_phase
  end

end
