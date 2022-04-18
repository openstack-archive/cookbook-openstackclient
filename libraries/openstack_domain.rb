
#
# Copyright:: 2016-2022, cloudbau GmbH
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

require_relative 'openstack_base'
module OpenstackclientCookbook
  class OpenstackDomain < OpenstackBase
    resource_name :openstack_domain
    provides :openstack_domain

    property :domain_name, String, name_property: true
    property :connection_params, Hash, required: true

    default_action :create

    action :create do
      domain = new_resource.connection.domains.find { |u| u.id == new_resource.domain_name } ||
               new_resource.connection.domains.find { |u| u.name == new_resource.domain_name }
      unless domain
        converge_by "creating domain #{new_resource.domain_name}" do
          new_resource.connection.domains.create(name: new_resource.domain_name)
        end
      end
    end

    action :delete do
      domain = new_resource.connection.domains.find { |u| u.name == new_resource.domain_name }
      if domain
        converge_by "deleting domain #{new_resource.domain_name}" do
          domain.update(enabled: false)
          domain.destroy
        end
      end
    end
  end
end
