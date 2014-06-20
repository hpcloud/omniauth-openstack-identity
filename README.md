# Omniauth::OpenstackIdentity

This gem provides a really simple way to authenticate against the OpenStack
Identity service using OmniAuth.


## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-openstack-identity'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-openstack-identity


## Usage

This gem supports both version 2 & version 3 of the Keystone API. You can use
version 2, version 3 or both.

Assuming you are using a Rails application, add the requisite provider(s) to
your omniauth.rb file like so:

    Rails.application.config.middleware.use OmniAuth::Builder do
      ...
      provider :developer unless Rails.env.production?

      # Identity v2 endpoint will look like this: http://10.10.10.10:5000/v2.0
      provider :openstack_identity_v2, "<identity v2 endpoint>"

      # Identity v3 endpoint will look like this: http://10.10.10.10:5000/v3
      provider :openstack_identity_v3, "<identity v3 endpoint>"
      ...
    end

Assuming a Sinatra app, add the requisite provider(s) inline like so:

    require 'omniauth-openstack-identity'
    use OmniAuth::Strategies::OpenstackIdentityV2, "<identity v2 endpoint>"
    use OmniAuth::Strategies::OpenstackIdentityV3, "<identity v3 endpoint>"


## Auth Hash Schema

The following information is provided back to you for this provider:

    {
      uid: '12345',
      info: {
        nickname: 'login', # may be email
        email: 'someone@example.com'
      },
      credentials: {
        token: 'thetoken' # can be used to auth to the API
      },
      extra: { raw_info: raw_api_response }
    }


## Contributing

1. Fork it ( https://github.com/[my-github-username]/omniauth-openstack-identity/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
