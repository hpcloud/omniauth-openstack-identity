require 'spec_helper'

describe OmniAuth::Strategies::OpenstackIdentityV2 do

  let(:keystone_v2_url) { 'https://some.other.site.com/api/v2.0' }

  subject do
    OmniAuth::Strategies::OpenstackIdentityV2.new({})
  end

  context "" do
  end

end
