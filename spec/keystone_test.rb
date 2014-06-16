require 'keystone_v2'

ks = KeystoneV2.new({'url'=>"http://192.168.27.100:5000/v2.0/",
                  'username'=>"demo",
                  'password'=>"password",
                  'tenant_name'=>"demo"})
resp = ks.authenticate
puts resp['access']['token']['id']
