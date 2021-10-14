
#
# Copyright:: 2016-2021, cloudbau GmbH
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

connection_params = {
  openstack_auth_url: 'http://devstack.test:5000/v3/auth/tokens',
  openstack_username: 'admin',
  openstack_api_key: 'password',
  openstack_project_name: 'admin',
  openstack_domain_id: 'default',
}

%w(public internal admin).each do |interface|
  openstack_endpoint "myendpoint_#{interface}" do
    service_name 'myservice'
    interface interface
    url "http://localhost:80/#{interface}"
    connection_params connection_params
  end

  openstack_endpoint "myendpoint_#{interface}" do
    service_name 'myservice'
    interface interface
    url "http://localhost:80/#{interface}"
    connection_params connection_params
    action :delete
  end
end
