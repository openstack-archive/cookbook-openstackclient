#  encoding: UTF-8
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
      user = connection.users.find { |u| u.name == user_name }
      project = connection.projects.find { |p| p.name == project_name }
      domain = connection.domains.find { |u| u.name == domain_name }
      if user
        log "User with name: \"#{user_name}\" already exists"
      elsif domain
        connection.users.create(
          name: user_name,
          domain_id: domain.id,
          email: email,
          default_project_id: project ? project.id : nil,
          password: password
        )
      else
        connection.users.create(
          name: user_name,
          email: email,
          default_project_id: project ? project.id : nil,
          password: password
        )
      end
    end

    action :delete do
      user = connection.users.find { |u| u.name == user_name }
      if user
        user.destroy
      else
        log "User with name: \"#{user_name}\" doesn't exist"
      end
    end

    # Grant a role in a project
    action :grant_role do
      user = connection.users.find { |u| u.name == user_name }
      project = connection.projects.find { |p| p.name == project_name }
      role = connection.roles.find { |r| r.name == role_name }
      project.grant_role_to_user role.id, user.id if role && project && user
    end

    action :revoke_role do
      user = connection.users.find { |u| u.name == user_name }
      project = connection.projects.find { |p| p.name == project_name }
      role = connection.roles.find { |r| r.name == role_name }
      project.revoke_role_from_user role.id, user.id if role && project && user
    end

    # Grant a role in a domain
    # Note: in spite of what the action name may suggest, the domain name is
    # only used to identify a user who is in that domain. This action grants
    # the user a role in the domain.
    action :grant_domain do
      user = connection.users.find { |u| u.name == user_name }
      domain = connection.domains.find { |p| p.name == domain_name }
      role = connection.roles.find { |r| r.name == role_name }
      connection.grant_domain_user_role(
        domain.id, user.id, role.id) if role && domain && user
    end

    action :revoke_domain do
      user = connection.users.find { |u| u.name == user_name }
      domain = connection.domains.find { |p| p.name == domain_name }
      role = connection.roles.find { |r| r.name == role_name }
      connection.revoke_domain_user_role(
        domain.id, user.id, role.id) if role && domain && user
    end
  end
end
