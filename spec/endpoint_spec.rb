
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
require_relative '../libraries/openstack_endpoint'

describe 'openstackclient_test::endpoint' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(
      UBUNTU_OPTS.merge(step_into: ['openstack_endpoint'])
    )
    runner.converge(described_recipe)
  end

  let(:services_dub) do
    double :services,
           find: double(id: 1)
  end

  let(:endpoints_empty) do
    double :endpoints,
           create: true,
           destroy: true,
           find: nil
  end

  let(:endpoints_populated) do
    double :endpoints,
           create: true,
           destroy: true,
           find: double(id: 2)
  end

  context 'no endpoints defined' do
    let(:connection_dub) do
      double :fog_connection,
             services: services_dub,
             endpoints: endpoints_empty
    end

    before do
      allow_any_instance_of(OpenstackclientCookbook::OpenstackEndpoint)
        .to receive(:connection).and_return(connection_dub)
    end

    it do
      expect(connection_dub).to receive(:endpoints)
      chef_run
    end

    it do
      expect(connection_dub).to receive(:services)
      chef_run
    end

    %w(public internal admin).each do |interface|
      it do
        expect(chef_run).to write_log(
          "#{interface}_endpoint for \"myservice\" doesn't exist"
        )
      end

      it do
        expect(chef_run).not_to write_log(
          "#{interface}_endpoint for \"myservice\" already exists"
        )
      end

      it do
        expect(chef_run).to create_openstack_endpoint("myendpoint_#{interface}")
      end

      it do
        expect(chef_run).to delete_openstack_endpoint("myendpoint_#{interface}")
      end

      it do
        expect(endpoints_empty).to receive(:create)
          .with(
            interface: interface,
            url: "http://localhost:80/#{interface}",
            service_id: 1,
            name: "myendpoint_#{interface}",
            region: nil
          )
        chef_run
      end
      it do
        expect(endpoints_empty).not_to receive(:destroy)
        chef_run
      end
    end
  end

  context 'endpoints defined' do
    let(:connection_dub) do
      double :fog_connection,
             services: services_dub,
             endpoints: endpoints_populated
    end
    before do
      allow_any_instance_of(OpenstackclientCookbook::OpenstackEndpoint)
        .to receive(:connection).and_return(connection_dub)
    end
    it do
      expect(connection_dub).to receive(:endpoints)
      chef_run
    end

    it do
      expect(connection_dub).to receive(:services)
      chef_run
    end
    %w(public internal admin).each do |interface|
      it do
        expect(chef_run).not_to write_log(
          "#{interface}_endpoint for \"myservice\" doesn't exist"
        )
      end

      it do
        expect(chef_run).to write_log(
          "#{interface}_endpoint for \"myservice\" already exists"
        )
      end

      it do
        expect(chef_run).to create_openstack_endpoint("myendpoint_#{interface}")
      end

      it do
        expect(chef_run).to delete_openstack_endpoint("myendpoint_#{interface}")
      end

      it do
        expect(endpoints_populated).not_to receive(:create)
          .with(
            interface: interface,
            url: "http://localhost:80/#{interface}",
            service_id: 1,
            name: "myendpoint_#{interface}",
            region: nil
          )
        chef_run
      end

      it do
        expect(endpoints_populated).to receive(:destroy)
          .with(2)
        chef_run
      end
    end
  end
end
