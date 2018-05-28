
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

require_relative 'openstack_base'
module OpenstackclientCookbook
  class OpenstackUser < OpenstackBase
    resource_name :openstack_user

    property :user_name, String, name_property: true
    property :email, String, default: 'defaultmail'
    property :password, String, default: 'defaultpass'
    property :role_name, String
    property :project_name, String
    property :domain_name, String
    property :connection_params, Hash, required: true

    default_action :create

    action :create do
      user = new_resource.connection.users.find { |u| u.name == new_resource.user_name }
      project = new_resource.connection.projects.find { |p| p.name == new_resource.project_name }
      domain = new_resource.connection.domains.find { |u| u.name == new_resource.domain_name }
      if user
        log "User with name: \"#{new_resource.user_name}\" already exists"
      elsif domain
        new_resource.connection.users.create(
          name: new_resource.user_name,
          domain_id: domain.id,
          email: new_resource.email,
          default_project_id: project ? project.id : nil,
          password: new_resource.password
        )
      else
        new_resource.connection.users.create(
          name: new_resource.user_name,
          email: new_resource.email,
          default_project_id: project ? project.id : nil,
          password: new_resource.password
        )
      end
    end

    action :delete do
      user = new_resource.connection.users.find { |u| u.name == new_resource.user_name }
      if user
        user.destroy
      else
        log "User with name: \"#{new_resource.user_name}\" doesn't exist"
      end
    end

    # Grant a role in a project
    action :grant_role do
      user = new_resource.connection.users.find { |u| u.name == new_resource.user_name }
      project = new_resource.connection.projects.find { |p| p.name == new_resource.project_name }
      role = new_resource.connection.roles.find { |r| r.name == new_resource.role_name }
      project.grant_role_to_user role.id, user.id if role && project && user
    end

    action :revoke_role do
      user = new_resource.connection.users.find { |u| u.name == new_resource.user_name }
      project = new_resource.connection.projects.find { |p| p.name == new_resource.project_name }
      role = new_resource.connection.roles.find { |r| r.name == new_resource.role_name }
      project.revoke_role_from_user role.id, user.id if role && project && user
    end

    # Grant a role in a domain
    # Note: in spite of what the action name may suggest, the domain name is
    # only used to identify a user who is in that domain. This action grants
    # the user a role in the domain.
    action :grant_domain do
      user = new_resource.connection.users.find { |u| u.name == new_resource.user_name }
      domain = new_resource.connection.domains.find { |p| p.name == new_resource.domain_name }
      role = new_resource.connection.roles.find { |r| r.name == new_resource.role_name }
      user.grant_role role.id if role && domain && user
    end

    action :revoke_domain do
      user = new_resource.connection.users.find { |u| u.name == new_resource.user_name }
      domain = new_resource.connection.domains.find { |p| p.name == new_resource.domain_name }
      role = new_resource.connection.roles.find { |r| r.name == new_resource.role_name }
      user.revoke_role role.id if role && domain && user
    end
  end
end
