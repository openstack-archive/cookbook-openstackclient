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
  class OpenstackEndpoint < OpenstackBase
    resource_name :openstack_endpoint

    property :endpoint_name, String, name_property: true
    property :service_name, String, required: true
    property :interface, String, required: true
    property :url, String, required: true
    property :region, String
    property :connection_params, Hash, required: true

    default_action :create

    action :create do
      service = connection.services.find { |s| s.name == service_name }
      endpoint = connection.endpoints.find do |e|
        e.service_id == service.id && e.interface == interface
      end

      if endpoint
        log "#{interface}_endpoint for \"#{service_name}\" already exists"
      else
        connection.endpoints.create(
          interface: interface,
          url: url,
          service_id: service.id,
          name: endpoint_name,
          region: region
        )
      end
    end

    action :delete do
      service = connection.services.find { |s| s.name == service_name }
      endpoint = connection.endpoints.find do |e|
        e.service_id == service.id && e.interface == interface
      end
      if endpoint
        connection.endpoints.destroy(endpoint.id)
      else
        log "#{interface}_endpoint for \"#{service_name}\" doesn't exist"
      end
    end
  end
end
