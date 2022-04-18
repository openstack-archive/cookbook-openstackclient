
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
  class OpenstackProject < OpenstackBase
    resource_name :openstack_project
    provides :openstack_project

    property :project_name, String, name_property: true
    property :domain_name, String, default: 'Default'
    property :connection_params, Hash, required: true

    default_action :create

    action :create do
      domain = new_resource.connection.domains.find { |d| d.name == new_resource.domain_name }
      project = new_resource.connection.projects.find do |p|
        (p.name == new_resource.project_name) && (domain ? p.domain_id == domain.id : {})
      end
      if !project && domain
        converge_by "creating project #{new_resource.project_name} in domain #{new_resource.domain_name}" do
          new_resource.connection.projects.create(
            name: new_resource.project_name,
            domain_id: domain.id
          )
        end
      elsif !project
        converge_by "creating project #{new_resource.project_name}" do
          new_resource.connection.projects.create(
            name: new_resource.project_name
          )
        end
      end
    end

    action :delete do
      domain = new_resource.connection.domains.find { |d| d.name == new_resource.domain_name }
      project = new_resource.connection.projects.find do |p|
        (p.name == new_resource.project_name) && (domain ? p.domain_id == domain.id : {})
      end
      if project && domain
        converge_by "deleting project #{new_resource.project_name} in domain #{new_resource.domain_name}" do
          project.destroy
        end
      elsif project
        converge_by "deleting project #{new_resource.project_name}" do
          project.destroy
        end
      end
    end
  end
end
