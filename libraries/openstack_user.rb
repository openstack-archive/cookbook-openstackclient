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
  class OpenstackUser < OpenstackBase
    resource_name :openstack_user
    provides :openstack_user

    property :user_name, String, name_property: true
    property :email, String, default: 'defaultmail'
    property :password, String, default: 'defaultpass'
    property :role_name, String
    property :project_name, String
    property :domain_name, String
    property :connection_params, Hash, required: true

    default_action :create

    action :create do
      domain = new_resource.connection.domains.find { |d| d.name == new_resource.domain_name }
      project = new_resource.connection.projects.find do |p|
        (p.name == new_resource.project_name) && (domain ? p.domain_id == domain.id : {})
      end
      user = new_resource.connection.users.find_by_name(
          new_resource.user_name,
          domain ? { domain_id: domain.id } : {}
        ).first
      if !user && domain
        converge_by "creating user #{new_resource.user_name} in domain #{new_resource.domain_name}" do
          new_resource.connection.users.create(
            name: new_resource.user_name,
            domain_id: domain.id,
            email: new_resource.email,
            default_project_id: project ? project.id : nil,
            password: new_resource.password
          )
        end
      elsif !user
        converge_by "creating user #{new_resource.user_name}" do
          new_resource.connection.users.create(
            name: new_resource.user_name,
            email: new_resource.email,
            default_project_id: project ? project.id : nil,
            password: new_resource.password
          )
        end
      end
    end

    action :delete do
      domain = new_resource.connection.domains.find { |d| d.name == new_resource.domain_name }
      user = new_resource.connection.users.find_by_name(
          new_resource.user_name,
          domain ? { domain_id: domain.id } : {}
        ).first
      if user
        converge_by "deleting user #{new_resource.user_name}" do
          user.destroy
        end
      end
    end

    # Grant a role in a project
    action :grant_role do
      domain = new_resource.connection.domains.find { |d| d.name == new_resource.domain_name }
      project = new_resource.connection.projects.find do |p|
        (p.name == new_resource.project_name) && (domain ? p.domain_id == domain.id : {})
      end
      role = new_resource.connection.roles.find { |r| r.name == new_resource.role_name }
      user = new_resource.connection.users.find_by_name(
          new_resource.user_name,
          domain ? { domain_id: domain.id } : {}
        ).first
      if user && role && domain && project && !user.check_role(role.id)
        converge_by "granting role #{new_resource.role_name} to user #{new_resource.user_name}" do
          project.grant_role_to_user role.id, user.id
        end
      end
    end

    action :revoke_role do
      domain = new_resource.connection.domains.find { |d| d.name == new_resource.domain_name }
      user = new_resource.connection.users.find_by_name(
          new_resource.user_name,
          domain ? { domain_id: domain.id } : {}
        ).first
      project = new_resource.connection.projects.find do |p|
        (p.name == new_resource.project_name) && (domain ? p.domain_id == domain.id : {})
      end
      role = new_resource.connection.roles.find { |r| r.name == new_resource.role_name }

      if user && role && project && user.check_role(role.id)
        converge_by "revoking role #{new_resource.role_name} to user #{new_resource.user_name}" do
          project.revoke_role_from_user role.id, user.id
        end
      end
    end

    # Grant a role in a domain
    # Note: in spite of what the action name may suggest, the domain name is
    # only used to identify a user who is in that domain. This action grants
    # the user a role in the domain.
    action :grant_domain do
      domain = new_resource.connection.domains.find { |d| d.name == new_resource.domain_name }
      user = new_resource.connection.users.find_by_name(
          new_resource.user_name,
          domain ? { domain_id: domain.id } : {}
        ).first
      role = new_resource.connection.roles.find { |r| r.name == new_resource.role_name }
      if user && role && domain && !user.check_role(role.id)
        converge_by "granting role #{new_resource.role_name} to user #{new_resource.user_name} in domain #{new_resource.domain_name}" do
          user.grant_role role.id
        end
      end
    end

    action :revoke_domain do
      domain = new_resource.connection.domains.find { |d| d.name == new_resource.domain_name }
      user = new_resource.connection.users.find_by_name(
          new_resource.user_name,
          domain ? { domain_id: domain.id } : {}
        ).first
      role = new_resource.connection.roles.find { |r| r.name == new_resource.role_name }
      if user && role && domain && user.check_role(role.id)
        converge_by "revoking role #{new_resource.role_name} to user #{new_resource.user_name} in domain #{new_resource.domain_name}" do
          user.revoke_role role.id
        end
      end
    end
  end
end
