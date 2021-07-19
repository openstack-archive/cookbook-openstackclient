
#
#  Copyright 2016 cloudbau GmbH
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

source 'https://supermarket.chef.io'

solver :ruby, :required

%w(
  -common
  -dns
  -identity
  -image
  -integration-test
  -network
  -ops-database
  -ops-messaging
).each do |cookbook|
  if Dir.exist?("../cookbook-openstack#{cookbook}")
    cookbook "openstack#{cookbook}", path: "../cookbook-openstack#{cookbook}", group: 'integration'
  else
    cookbook "openstack#{cookbook}",
      git: "https://opendev.org/openstack/cookbook-openstack#{cookbook}",
      branch: 'stable/stein',
      group: 'integration'
  end
end

# TODO(ramereth): Remove after this PR gets included in a release
# # https://github.com/joyofhex/cookbook-bind/pull/60
cookbook 'bind', github: 'joyofhex/cookbook-bind'

metadata

# cookbook for testing LWRPs:
cookbook 'openstackclient_test', path: 'spec/cookbooks/openstackclient_test'
