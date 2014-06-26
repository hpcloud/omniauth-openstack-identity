# OpenstackIdentity

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


## Authentication Options

### Identity/Keystone Version 2

#### Option 1 - Unscoped token via Username+Password

- Input:
    Username:  demo
    Password:  password

- Output:
    {
       "access":{
          "token":{
             "issued_at":"2014-06-23T21:38:16.239131",
             "expires":"2014-06-24T21:38:16Z",
             "id":"MIIC7wYJKoZIhvcNAQcCoIIC4DCCAtwCAQExCTAHBgUrDgMCGjCCAUUGCSqGSIb3DQEHAaCCATYEggEyeyJhY2Nlc3MiOiB7InRva2VuIjogeyJpc3N1ZWRfYXQiOiAiMjAxNC0wNi0yM1QyMTozODoxNi4yMzkxMzEiLCAiZXhwaXJlcyI6ICIyMDE0LTA2LTI0VDIxOjM4OjE2WiIsICJpZCI6ICJwbGFjZWhvbGRlciJ9LCAic2VydmljZUNhdGFsb2ciOiBbXSwgInVzZXIiOiB7InVzZXJuYW1lIjogImRlbW8iLCAicm9sZXNfbGlua3MiOiBbXSwgImlkIjogImE1ZjkwMGEwYTgyZDRiNjZhZTM3MDQ5NmU2NWY3MWMxIiwgInJvbGVzIjogW10sICJuYW1lIjogImRlbW8ifSwgIm1ldGFkYXRhIjogeyJpc19hZG1pbiI6IDAsICJyb2xlcyI6IFtdfX19MYIBgTCCAX0CAQEwXDBXMQswCQYDVQQGEwJVUzEOMAwGA1UECAwFVW5zZXQxDjAMBgNVBAcMBVVuc2V0MQ4wDAYDVQQKDAVVbnNldDEYMBYGA1UEAwwPd3d3LmV4YW1wbGUuY29tAgEBMAcGBSsOAwIaMA0GCSqGSIb3DQEBAQUABIIBAHPbhW7hiw5+CMOL0+5cc7zvLASY-kaWmdfhoBL1Cb5lgQsaBAFGObFJeH4bNJyiTR6c0IT93cvlN-DluGXZ-6DREGVlKUe9V9i-z+6XqGnnhJ4KwOeZoGPOwc2Vjh+NOlYw3c59DaDhWRL92DxhEgtuQK7ktrrNLEJ-kVyBqljHxgSNSkS7yev1kwwnYd26wg1--1jajzul5lHxzXXgEfvC9diKgXe9kOJTBTIy-lpH4zVYyTJpZFNRR9B7WpOrc+dt8QZdbHjCF3fKweUMFJTnjwtduYzm4-qqxizwOJXOqUEWdksRdxVDhslql1LhqBirLXcGyshYwAWxKtvZuBM="
          },
          "serviceCatalog":[
          ],
          "user":{
             "username":"demo",
             "roles_links":[
             ],
             "id":"a5f900a0a82d4b66ae370496e65f71c1",
             "roles":[
             ],
             "name":"demo"
          },
          "metadata":{
             "is_admin":0,
             "roles":[
             ]
          }
       }
    }


<!-- #### Option 2 - Scoped token via TenantName/Username+Password

* Input:
    TenantName/Username: demo/demo
    Password:            password

- Output:
    {
       "access":{
          "token":{
             "issued_at":"2014-06-23T21:35:25.089314",
             "expires":"2014-06-24T21:35:25Z",
             "id":"MIINWwYJKoZIhvcNAQcCoIINTDCCDUgCAQExCTAHBgUrDgMCGjCCC7EGCSqGSIb3DQEHAaCCC6IEggueeyJhY2Nlc3MiOiB7InRva2VuIjogeyJpc3N1ZWRfYXQiOiAiMjAxNC0wNi0yM1QyMTozNToyNS4wODkzMTQiLCAiZXhwaXJlcyI6ICIyMDE0LTA2LTI0VDIxOjM1OjI1WiIsICJpZCI6ICJwbGFjZWhvbGRlciIsICJ0ZW5hbnQiOiB7ImRlc2NyaXB0aW9uIjogbnVsbCwgImVuYWJsZWQiOiB0cnVlLCAiaWQiOiAiMTc0YjE0NjRiMjIzNGVlMGE1NmM0NjdlZDA3ZDYyZjQiLCAibmFtZSI6ICJkZW1vIn19LCAic2VydmljZUNhdGFsb2ciOiBbeyJlbmRwb2ludHMiOiBbeyJhZG1pblVSTCI6ICJodHRwOi8vMTAuMC4yLjE1Ojg3NzQvdjIvMTc0YjE0NjRiMjIzNGVlMGE1NmM0NjdlZDA3ZDYyZjQiLCAicmVnaW9uIjogIlJlZ2lvbk9uZSIsICJpbnRlcm5hbFVSTCI6ICJodHRwOi8vMTAuMC4yLjE1Ojg3NzQvdjIvMTc0YjE0NjRiMjIzNGVlMGE1NmM0NjdlZDA3ZDYyZjQiLCAiaWQiOiAiMzRiMWRmNWNlOGNiNDRiYTg1NWFlMWU4YmVjYjQxZmEiLCAicHVibGljVVJMIjogImh0dHA6Ly8xMC4wLjIuMTU6ODc3NC92Mi8xNzRiMTQ2NGIyMjM0ZWUwYTU2YzQ2N2VkMDdkNjJmNCJ9XSwgImVuZHBvaW50c19saW5rcyI6IFtdLCAidHlwZSI6ICJjb21wdXRlIiwgIm5hbWUiOiAibm92YSJ9LCB7ImVuZHBvaW50cyI6IFt7ImFkbWluVVJMIjogImh0dHA6Ly8xMC4wLjIuMTU6ODc3Ni92Mi8xNzRiMTQ2NGIyMjM0ZWUwYTU2YzQ2N2VkMDdkNjJmNCIsICJyZWdpb24iOiAiUmVnaW9uT25lIiwgImludGVybmFsVVJMIjogImh0dHA6Ly8xMC4wLjIuMTU6ODc3Ni92Mi8xNzRiMTQ2NGIyMjM0ZWUwYTU2YzQ2N2VkMDdkNjJmNCIsICJpZCI6ICIwN2Y5NTQzNjg3YzA0YzBhOWI2MmI4MzEyYTIwMmQzYyIsICJwdWJsaWNVUkwiOiAiaHR0cDovLzEwLjAuMi4xNTo4Nzc2L3YyLzE3NGIxNDY0YjIyMzRlZTBhNTZjNDY3ZWQwN2Q2MmY0In1dLCAiZW5kcG9pbnRzX2xpbmtzIjogW10sICJ0eXBlIjogInZvbHVtZXYyIiwgIm5hbWUiOiAiY2luZGVyIn0sIHsiZW5kcG9pbnRzIjogW3siYWRtaW5VUkwiOiAiaHR0cDovLzEwLjAuMi4xNTo4Nzc0L3YzIiwgInJlZ2lvbiI6ICJSZWdpb25PbmUiLCAiaW50ZXJuYWxVUkwiOiAiaHR0cDovLzEwLjAuMi4xNTo4Nzc0L3YzIiwgImlkIjogIjBhZjk2ODg3YmYwYTRmMDM5YWZhZWU5YTliMTQxYTA0IiwgInB1YmxpY1VSTCI6ICJodHRwOi8vMTAuMC4yLjE1Ojg3NzQvdjMifV0sICJlbmRwb2ludHNfbGlua3MiOiBbXSwgInR5cGUiOiAiY29tcHV0ZXYzIiwgIm5hbWUiOiAibm92YSJ9LCB7ImVuZHBvaW50cyI6IFt7ImFkbWluVVJMIjogImh0dHA6Ly8xMC4wLjIuMTU6MzMzMyIsICJyZWdpb24iOiAiUmVnaW9uT25lIiwgImludGVybmFsVVJMIjogImh0dHA6Ly8xMC4wLjIuMTU6MzMzMyIsICJpZCI6ICIyMWY1NDE0MzA1Mzk0YThmYTA5YWIxMWIwMzQ2M2Q2NSIsICJwdWJsaWNVUkwiOiAiaHR0cDovLzEwLjAuMi4xNTozMzMzIn1dLCAiZW5kcG9pbnRzX2xpbmtzIjogW10sICJ0eXBlIjogInMzIiwgIm5hbWUiOiAiczMifSwgeyJlbmRwb2ludHMiOiBbeyJhZG1pblVSTCI6ICJodHRwOi8vMTAuMC4yLjE1OjkyOTIiLCAicmVnaW9uIjogIlJlZ2lvbk9uZSIsICJpbnRlcm5hbFVSTCI6ICJodHRwOi8vMTAuMC4yLjE1OjkyOTIiLCAiaWQiOiAiMDk3NGU2MTZiNzg3NDMwNjg3OGU3YTY3YzgzNTU3OWMiLCAicHVibGljVVJMIjogImh0dHA6Ly8xMC4wLjIuMTU6OTI5MiJ9XSwgImVuZHBvaW50c19saW5rcyI6IFtdLCAidHlwZSI6ICJpbWFnZSIsICJuYW1lIjogImdsYW5jZSJ9LCB7ImVuZHBvaW50cyI6IFt7ImFkbWluVVJMIjogImh0dHA6Ly8xMC4wLjIuMTU6ODc3Ni92MS8xNzRiMTQ2NGIyMjM0ZWUwYTU2YzQ2N2VkMDdkNjJmNCIsICJyZWdpb24iOiAiUmVnaW9uT25lIiwgImludGVybmFsVVJMIjogImh0dHA6Ly8xMC4wLjIuMTU6ODc3Ni92MS8xNzRiMTQ2NGIyMjM0ZWUwYTU2YzQ2N2VkMDdkNjJmNCIsICJpZCI6ICI3MTg3YmFiN2VhODQ0ZjdjOTY5YTBmYWRiNGY5ODc4NiIsICJwdWJsaWNVUkwiOiAiaHR0cDovLzEwLjAuMi4xNTo4Nzc2L3YxLzE3NGIxNDY0YjIyMzRlZTBhNTZjNDY3ZWQwN2Q2MmY0In1dLCAiZW5kcG9pbnRzX2xpbmtzIjogW10sICJ0eXBlIjogInZvbHVtZSIsICJuYW1lIjogImNpbmRlciJ9LCB7ImVuZHBvaW50cyI6IFt7ImFkbWluVVJMIjogImh0dHA6Ly8xMC4wLjIuMTU6ODc3My9zZXJ2aWNlcy9BZG1pbiIsICJyZWdpb24iOiAiUmVnaW9uT25lIiwgImludGVybmFsVVJMIjogImh0dHA6Ly8xMC4wLjIuMTU6ODc3My9zZXJ2aWNlcy9DbG91ZCIsICJpZCI6ICI0ZDk3YWVhNDNiMmI0MDAzYmFhZTY1Nzk4ZjdkODVlNiIsICJwdWJsaWNVUkwiOiAiaHR0cDovLzEwLjAuMi4xNTo4NzczL3NlcnZpY2VzL0Nsb3VkIn1dLCAiZW5kcG9pbnRzX2xpbmtzIjogW10sICJ0eXBlIjogImVjMiIsICJuYW1lIjogImVjMiJ9LCB7ImVuZHBvaW50cyI6IFt7ImFkbWluVVJMIjogImh0dHA6Ly8xMC4wLjIuMTU6MzUzNTcvdjIuMCIsICJyZWdpb24iOiAiUmVnaW9uT25lIiwgImludGVybmFsVVJMIjogImh0dHA6Ly8xMC4wLjIuMTU6NTAwMC92Mi4wIiwgImlkIjogIjdhYWM4MjhkMmI3ODQzZjFhYzRjZjNhZWU1Y2Q5MGViIiwgInB1YmxpY1VSTCI6ICJodHRwOi8vMTAuMC4yLjE1OjUwMDAvdjIuMCJ9XSwgImVuZHBvaW50c19saW5rcyI6IFtdLCAidHlwZSI6ICJpZGVudGl0eSIsICJuYW1lIjogImtleXN0b25lIn1dLCAidXNlciI6IHsidXNlcm5hbWUiOiAiZGVtbyIsICJyb2xlc19saW5rcyI6IFtdLCAiaWQiOiAiYTVmOTAwYTBhODJkNGI2NmFlMzcwNDk2ZTY1ZjcxYzEiLCAicm9sZXMiOiBbeyJuYW1lIjogImFub3RoZXJyb2xlIn0sIHsibmFtZSI6ICJNZW1iZXIifV0sICJuYW1lIjogImRlbW8ifSwgIm1ldGFkYXRhIjogeyJpc19hZG1pbiI6IDAsICJyb2xlcyI6IFsiYzE3ODMwMjJkZWU0NGU2MDgzOGZjMjk5M2I0OGUxN2QiLCAiNWMwYWNhMGYyYWE3NGVmNDk5N2Y3MTc0NWQ0NTM4Y2YiXX19fTGCAYEwggF9AgEBMFwwVzELMAkGA1UEBhMCVVMxDjAMBgNVBAgMBVVuc2V0MQ4wDAYDVQQHDAVVbnNldDEOMAwGA1UECgwFVW5zZXQxGDAWBgNVBAMMD3d3dy5leGFtcGxlLmNvbQIBATAHBgUrDgMCGjANBgkqhkiG9w0BAQEFAASCAQCUERIqe-s691u+VxzUN4Z7yl2jAru7-YrlT0Z5K3afJnNKOvEV4rlRHhk5wC94ZyodKQ8L0LuPp-FkK+qKsqXFoQooOyD3AYGbx3UkJN0GKlEzpgqZU6MX7Sx9Snk58P6cqq2Vb90yKo5HbLjUyTbd29ZvEyqA4m+1ZVx6-3DJwo6QedUVeD4HArmmkcOawplfgVYHPk2G1hkX48ylo5idYFQCrnEewVnSq4RGsnvNIFDIhzBeMBLpRkL+rgg2ctEvSpbrrReFbD23POVQBXbMYxJnKeLzRdeW8YmFxQOb9Lay5rAjWN5WzCg+uCCBLpz9ZhPHL78ImTB0YI1jgJcE",
             "tenant":{
                "description":null,
                "enabled":true,
                "id":"174b1464b2234ee0a56c467ed07d62f4",
                "name":"demo"
             }
          },
          "serviceCatalog":[
             {
                "endpoints":[
                   {
                      "adminURL":"http://10.0.2.15:8774/v2/174b1464b2234ee0a56c467ed07d62f4",
                      "region":"RegionOne",
                      "internalURL":"http://10.0.2.15:8774/v2/174b1464b2234ee0a56c467ed07d62f4",
                      "id":"34b1df5ce8cb44ba855ae1e8becb41fa",
                      "publicURL":"http://10.0.2.15:8774/v2/174b1464b2234ee0a56c467ed07d62f4"
                   }
                ],
                "endpoints_links":[

                ],
                "type":"compute",
                "name":"nova"
             },
             {
                "endpoints":[
                   {
                      "adminURL":"http://10.0.2.15:8776/v2/174b1464b2234ee0a56c467ed07d62f4",
                      "region":"RegionOne",
                      "internalURL":"http://10.0.2.15:8776/v2/174b1464b2234ee0a56c467ed07d62f4",
                      "id":"07f9543687c04c0a9b62b8312a202d3c",
                      "publicURL":"http://10.0.2.15:8776/v2/174b1464b2234ee0a56c467ed07d62f4"
                   }
                ],
                "endpoints_links":[

                ],
                "type":"volumev2",
                "name":"cinder"
             },
             {
                "endpoints":[
                   {
                      "adminURL":"http://10.0.2.15:8774/v3",
                      "region":"RegionOne",
                      "internalURL":"http://10.0.2.15:8774/v3",
                      "id":"0af96887bf0a4f039afaee9a9b141a04",
                      "publicURL":"http://10.0.2.15:8774/v3"
                   }
                ],
                "endpoints_links":[

                ],
                "type":"computev3",
                "name":"nova"
             },
             {
                "endpoints":[
                   {
                      "adminURL":"http://10.0.2.15:3333",
                      "region":"RegionOne",
                      "internalURL":"http://10.0.2.15:3333",
                      "id":"21f5414305394a8fa09ab11b03463d65",
                      "publicURL":"http://10.0.2.15:3333"
                   }
                ],
                "endpoints_links":[

                ],
                "type":"s3",
                "name":"s3"
             },
             {
                "endpoints":[
                   {
                      "adminURL":"http://10.0.2.15:9292",
                      "region":"RegionOne",
                      "internalURL":"http://10.0.2.15:9292",
                      "id":"0974e616b7874306878e7a67c835579c",
                      "publicURL":"http://10.0.2.15:9292"
                   }
                ],
                "endpoints_links":[

                ],
                "type":"image",
                "name":"glance"
             },
             {
                "endpoints":[
                   {
                      "adminURL":"http://10.0.2.15:8776/v1/174b1464b2234ee0a56c467ed07d62f4",
                      "region":"RegionOne",
                      "internalURL":"http://10.0.2.15:8776/v1/174b1464b2234ee0a56c467ed07d62f4",
                      "id":"7187bab7ea844f7c969a0fadb4f98786",
                      "publicURL":"http://10.0.2.15:8776/v1/174b1464b2234ee0a56c467ed07d62f4"
                   }
                ],
                "endpoints_links":[

                ],
                "type":"volume",
                "name":"cinder"
             },
             {
                "endpoints":[
                   {
                      "adminURL":"http://10.0.2.15:8773/services/Admin",
                      "region":"RegionOne",
                      "internalURL":"http://10.0.2.15:8773/services/Cloud",
                      "id":"4d97aea43b2b4003baae65798f7d85e6",
                      "publicURL":"http://10.0.2.15:8773/services/Cloud"
                   }
                ],
                "endpoints_links":[

                ],
                "type":"ec2",
                "name":"ec2"
             },
             {
                "endpoints":[
                   {
                      "adminURL":"http://10.0.2.15:35357/v2.0",
                      "region":"RegionOne",
                      "internalURL":"http://10.0.2.15:5000/v2.0",
                      "id":"7aac828d2b7843f1ac4cf3aee5cd90eb",
                      "publicURL":"http://10.0.2.15:5000/v2.0"
                   }
                ],
                "endpoints_links":[

                ],
                "type":"identity",
                "name":"keystone"
             }
          ],
          "user":{
             "username":"demo",
             "roles_links":[

             ],
             "id":"a5f900a0a82d4b66ae370496e65f71c1",
             "roles":[
                {
                   "name":"anotherrole"
                },
                {
                   "name":"Member"
                }
             ],
             "name":"demo"
          },
          "metadata":{
             "is_admin":0,
             "roles":[
                "c1783022dee44e60838fc2993b48e17d",
                "5c0aca0f2aa74ef4997f71745d4538cf"
             ]
          }
       }
    } -->


### Identity/Keystone Version 3

#### Option 1 - Unscoped token via Username+Password

* Input:
    Username:  demo
    Password:  password

* Output:
    {
       "token":{
          "issued_at":"2014-06-23T21:42:04.858746Z",
          "extras":{
          },
          "methods":[
             "password"
          ],
          "expires_at":"2014-06-24T21:42:04.858696Z",
          "user":{
             "domain":{
                "id":"default",
                "name":"Default"
             },
             "id":"a5f900a0a82d4b66ae370496e65f71c1",
             "name":"demo"
          }
       }
    }


<!-- #### Option 2 - Unscoped token via Domain/Username+Password

* Input:
    DomainName/Username:  default/demo
    Password:             password

* Output:
    {
       "token":{
          "issued_at":"2014-06-23T21:43:58.855540Z",
          "extras":{

          },
          "methods":[
             "password"
          ],
          "expires_at":"2014-06-24T21:43:58.855457Z",
          "user":{
             "domain":{
                "id":"default",
                "name":"Default"
             },
             "id":"a5f900a0a82d4b66ae370496e65f71c1",
             "name":"demo"
          }
       }
    } -->

<!-- #### Option 3 - Scoped Token via Username/ProjectID+Password

* Input:
    Username/ProjectID:   demo/174b1464b2234ee0a56c467ed07d62f4
    Password:             password

* Output:

    {
       "token":{
          "methods":[
             "password"
          ],
          "roles":[
             {
                "id":"c1783022dee44e60838fc2993b48e17d",
                "name":"anotherrole"
             },
             {
                "id":"5c0aca0f2aa74ef4997f71745d4538cf",
                "name":"Member"
             }
          ],
          "expires_at":"2014-06-24T20:44:13.355597Z",
          "project":{
             "domain":{
                "id":"default",
                "name":"Default"
             },
             "id":"174b1464b2234ee0a56c467ed07d62f4",
             "name":"demo"
          },
          "catalog":[
             {
                "endpoints":[
                   {
                      "url":"http://10.0.2.15:8773/services/Cloud",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"5f1e6e15507440a9a6c9f527776a9cf0",
                      "interface":"public",
                      "id":"4d97aea43b2b4003baae65798f7d85e6"
                   },
                   {
                      "url":"http://10.0.2.15:8773/services/Cloud",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"5f1e6e15507440a9a6c9f527776a9cf0",
                      "interface":"internal",
                      "id":"8699846871714cecb88165250bebdafd"
                   },
                   {
                      "url":"http://10.0.2.15:8773/services/Admin",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"5f1e6e15507440a9a6c9f527776a9cf0",
                      "interface":"admin",
                      "id":"b1e11f45aaf24cdf8e94927c4fad8670"
                   }
                ],
                "type":"ec2",
                "id":"25d378e34f8e418e82a34dde6c76c68f"
             },
             {
                "endpoints":[
                   {
                      "url":"http://10.0.2.15:3333",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"fc32fbeadfca4e42bb23c2f9e3fb33d9",
                      "interface":"public",
                      "id":"21f5414305394a8fa09ab11b03463d65"
                   },
                   {
                      "url":"http://10.0.2.15:3333",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"fc32fbeadfca4e42bb23c2f9e3fb33d9",
                      "interface":"admin",
                      "id":"eddaea7fb6f745b7b49fb0f9a64c2f99"
                   },
                   {
                      "url":"http://10.0.2.15:3333",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"fc32fbeadfca4e42bb23c2f9e3fb33d9",
                      "interface":"internal",
                      "id":"f741082d27924cffba1ce16c388c5f49"
                   }
                ],
                "type":"s3",
                "id":"7788065cf9464c60b9b04c22b90a486e"
             },
             {
                "endpoints":[
                   {
                      "url":"http://10.0.2.15:9292",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"851e5439df6e4a3eb67b27c0b0893c5c",
                      "interface":"public",
                      "id":"0974e616b7874306878e7a67c835579c"
                   },
                   {
                      "url":"http://10.0.2.15:9292",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"851e5439df6e4a3eb67b27c0b0893c5c",
                      "interface":"internal",
                      "id":"229c03f1bf3a41c38b0718e36489d5e3"
                   },
                   {
                      "url":"http://10.0.2.15:9292",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"851e5439df6e4a3eb67b27c0b0893c5c",
                      "interface":"admin",
                      "id":"567d7ff289ee43c282f8b01c2f46c95e"
                   }
                ],
                "type":"image",
                "id":"7ead1e82e0b74a8eabdd771fc2f53eec"
             },
             {
                "endpoints":[
                   {
                      "url":"http://10.0.2.15:8776/v2/174b1464b2234ee0a56c467ed07d62f4",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"93d7b5846a7549b9a7e3f299f6a31ed8",
                      "interface":"admin",
                      "id":"07f9543687c04c0a9b62b8312a202d3c"
                   },
                   {
                      "url":"http://10.0.2.15:8776/v2/174b1464b2234ee0a56c467ed07d62f4",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"93d7b5846a7549b9a7e3f299f6a31ed8",
                      "interface":"public",
                      "id":"52024c878c9f4544a85c49845fb58e61"
                   },
                   {
                      "url":"http://10.0.2.15:8776/v2/174b1464b2234ee0a56c467ed07d62f4",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"93d7b5846a7549b9a7e3f299f6a31ed8",
                      "interface":"internal",
                      "id":"a51f21bd4ba94f338b5358651a6e2e71"
                   }
                ],
                "type":"volumev2",
                "id":"84711292f66647eaad962db1c7b57d27"
             },
             {
                "endpoints":[
                   {
                      "url":"http://10.0.2.15:8774/v2/174b1464b2234ee0a56c467ed07d62f4",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"9130dd43ab424dfe95dfa8153fb54e0e",
                      "interface":"public",
                      "id":"34b1df5ce8cb44ba855ae1e8becb41fa"
                   },
                   {
                      "url":"http://10.0.2.15:8774/v2/174b1464b2234ee0a56c467ed07d62f4",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"9130dd43ab424dfe95dfa8153fb54e0e",
                      "interface":"internal",
                      "id":"96957ff2640b4ce987053dec92a33efe"
                   },
                   {
                      "url":"http://10.0.2.15:8774/v2/174b1464b2234ee0a56c467ed07d62f4",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"9130dd43ab424dfe95dfa8153fb54e0e",
                      "interface":"admin",
                      "id":"af423a93747548e3a359daa4cc15352d"
                   }
                ],
                "type":"compute",
                "id":"87d0b7fd3d33487bbf3274d9409bdc5e"
             },
             {
                "endpoints":[
                   {
                      "url":"http://10.0.2.15:8776/v1/174b1464b2234ee0a56c467ed07d62f4",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"e4245556b078416090aff9ad36e346e7",
                      "interface":"internal",
                      "id":"7187bab7ea844f7c969a0fadb4f98786"
                   },
                   {
                      "url":"http://10.0.2.15:8776/v1/174b1464b2234ee0a56c467ed07d62f4",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"e4245556b078416090aff9ad36e346e7",
                      "interface":"admin",
                      "id":"a7b693c80eb94298a1d4da001703b86c"
                   },
                   {
                      "url":"http://10.0.2.15:8776/v1/174b1464b2234ee0a56c467ed07d62f4",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"e4245556b078416090aff9ad36e346e7",
                      "interface":"public",
                      "id":"e68f0f34a012445bac0097b6d3eea7ad"
                   }
                ],
                "type":"volume",
                "id":"9fdd7a3c33794ca68db0f077f5b601dc"
             },
             {
                "endpoints":[
                   {
                      "url":"http://10.0.2.15:8774/v3",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"9d0508fd2b78424bb7142526bdbbc0f1",
                      "interface":"internal",
                      "id":"0af96887bf0a4f039afaee9a9b141a04"
                   },
                   {
                      "url":"http://10.0.2.15:8774/v3",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"9d0508fd2b78424bb7142526bdbbc0f1",
                      "interface":"public",
                      "id":"9524560fad844382ba57106709447051"
                   },
                   {
                      "url":"http://10.0.2.15:8774/v3",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"9d0508fd2b78424bb7142526bdbbc0f1",
                      "interface":"admin",
                      "id":"a6c608ba9881444eba7c8d5221903e90"
                   }
                ],
                "type":"computev3",
                "id":"bb289a3db3294aac91a580c87f1e6f20"
             },
             {
                "endpoints":[
                   {
                      "url":"http://10.0.2.15:5000/v2.0",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"582cb29cac8048a1abe64c642febf4ee",
                      "interface":"public",
                      "id":"7aac828d2b7843f1ac4cf3aee5cd90eb"
                   },
                   {
                      "url":"http://10.0.2.15:5000/v2.0",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"582cb29cac8048a1abe64c642febf4ee",
                      "interface":"internal",
                      "id":"9c9e02aa275b4de283ac1a566426f69a"
                   },
                   {
                      "url":"http://10.0.2.15:35357/v2.0",
                      "region":"RegionOne",
                      "legacy_endpoint_id":"582cb29cac8048a1abe64c642febf4ee",
                      "interface":"admin",
                      "id":"d13fecbf0ec04188a3582dd0ccbda00b"
                   }
                ],
                "type":"identity",
                "id":"fbacea44e9664aec90ba05f232753336"
             }
          ],
          "extras":{

          },
          "user":{
             "domain":{
                "id":"default",
                "name":"Default"
             },
             "id":"a5f900a0a82d4b66ae370496e65f71c1",
             "name":"demo"
          },
          "issued_at":"2014-06-23T20:44:13.355645Z"
       }
    } -->



## Auth Hash Schema

The following information is provided back to you for this provider:

    {
      uid: user_id    # user ID from api response
      info: {
      },
      credentials: {
        username: username,
        secret: password,
        token: auth_token  # from Keystone
      },
      extra: { raw_info: full_raw_api_response (from Keystone) }
    }


## Contributing

1. Fork it ( https://github.com/[my-github-username]/omniauth-openstack-identity/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
