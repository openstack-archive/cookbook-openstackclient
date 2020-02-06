
#
# Copyright:: 2016 cloudbau GmbH
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
  class OpenstackRole < OpenstackBase
    resource_name :openstack_role

    property :role_name, String, name_property: true
    property :connection_params, Hash, required: true

    default_action :create

    action :create do
      role = new_resource.connection.roles.find { |r| r.name == new_resource.role_name }
      if role
        log "Role with name: \"#{new_resource.role_name}\" already exists"
      else
        new_resource.connection.roles.create name: new_resource.role_name
      end
    end

    action :delete do
      role = new_resource.connection.roles.find { |r| r.name == new_resource.role_name }
      if role
        role.destroy
      else
        log "Role with name: \"#{new_resource.role_name}\" doesn't exist"
      end
    end
  end
end
