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

require 'spec_helper'
require_relative '../libraries/openstack_service'

describe 'openstackclient_test::service' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(
      UBUNTU_OPTS.merge(step_into: ['openstack_service'])
    )
    runner.converge(described_recipe)
  end

  let(:services_empty) do
    double :service,
           create: true,
           destroy: true,
           find: nil
  end

  let(:found_service) do
    double :find,
           destroy: true
  end

  let(:services_populated) do
    double :service,
           create: true,
           destroy: true,
           find: found_service
  end

  context 'no services defined' do
    let(:connection_dub) do
      double :fog_connection,
             services: services_empty
    end

    before do
      allow_any_instance_of(OpenstackclientCookbook::OpenstackService)
        .to receive(:connection).and_return(connection_dub)
    end

    it do
      expect(connection_dub).to receive(:services)
      chef_run
    end

    it do
      expect(chef_run).to create_openstack_service('myservice')
    end

    it do
      expect(chef_run).to delete_openstack_service('myservice')
    end

    it do
      expect(chef_run).to write_log(
        'Service with name: "myservice" doesn\'t exist'
      )
    end

    it do
      expect(chef_run).not_to write_log(
        'Service with name: "myservice" already exists'
      )
    end

    it do
      expect(services_empty).to receive(:create)
        .with(
          name: 'myservice',
          type: 'mytype'
        )
      chef_run
    end

    it do
      expect(found_service).not_to receive(:destroy)
      chef_run
    end
  end

  context 'services defined' do
    let(:connection_dub) do
      double :fog_connection,
             services: services_populated
    end

    before do
      allow_any_instance_of(OpenstackclientCookbook::OpenstackService)
        .to receive(:connection).and_return(connection_dub)
    end

    it do
      expect(connection_dub).to receive(:services)
      chef_run
    end

    it do
      expect(chef_run).to create_openstack_service('myservice')
    end

    it do
      expect(chef_run).to delete_openstack_service('myservice')
    end

    it do
      expect(chef_run).not_to write_log(
        'Service with name: "myservice" doesn\'t exist'
      )
    end

    it do
      expect(chef_run).to write_log(
        'Service with name: "myservice" already exists'
      )
    end

    it do
      expect(services_empty).not_to receive(:create)
      chef_run
    end

    it do
      expect(found_service).to receive(:destroy)
      chef_run
    end
  end
end
