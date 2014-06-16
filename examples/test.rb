require 'rubygems'
require 'bundler'

Bundler.setup :default, :development, :example

require 'sinatra'
require 'omniauth-openstack-identity'

use Rack::Session::Cookie
use OmniAuth::Builder do
  provider :openstack_identity
end

get '/' do
  <<-HTML
    <a href='/auth/openstack_identity'>Sign in with Keystone</a>
    HTML
end

post '/auth/:name/callback' do
  auth = request.env['omniauth.auth']
  # do whatever you want with the information!
  puts auth.inspect
end
