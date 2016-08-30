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
require_relative '../libraries/openstack_domain'

describe 'openstackclient_test::domain' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(step_into: ['openstack_domain'])
    runner.converge(described_recipe)
  end

  let(:domains_empty) do
    double :domains,
           create: true,
           destroy: true,
           find: nil
  end

  let(:found_domain) do
    double :find,
           destroy: true
  end

  let(:domains_populated) do
    double :domains,
           create: true,
           destroy: true,
           find: found_domain
  end

  context 'no domains defined' do
    let(:connection_dub) do
      double :fog_connection,
             domains: domains_empty
    end

    before do
      allow_any_instance_of(OpenstackclientCookbook::OpenstackDomain)
        .to receive(:connection).and_return(connection_dub)
    end

    it do
      expect(connection_dub).to receive(:domains)
      chef_run
    end

    it do
      expect(chef_run).to create_openstack_domain('mydomain')
    end

    it do
      expect(chef_run).to delete_openstack_domain('mydomain')
    end

    it do
      expect(chef_run).to write_log(
        'Domain with name: "mydomain" doesn\'t exist'
      )
    end

    it do
      expect(chef_run).not_to write_log(
        'Domain with name: "mydomain" already exists'
      )
    end

    it do
      expect(domains_empty).to receive(:create)
        .with(name: 'mydomain')
      chef_run
    end

    it do
      expect(found_domain).not_to receive(:destory)
      chef_run
    end
  end

  context 'domains defined' do
    let(:connection_dub) do
      double :fog_connection,
             domains: domains_populated
    end

    before do
      allow_any_instance_of(OpenstackclientCookbook::OpenstackDomain)
        .to receive(:connection).and_return(connection_dub)
    end

    it do
      expect(connection_dub).to receive(:domains)
      chef_run
    end

    it do
      expect(chef_run).to create_openstack_domain('mydomain')
    end

    it do
      expect(chef_run).to delete_openstack_domain('mydomain')
    end

    it do
      expect(chef_run).not_to write_log(
        'Domain with name: "mydomain" doesn\'t exist'
      )
    end

    it do
      expect(chef_run).to write_log(
        'Domain with name: "mydomain" already exists'
      )
    end

    it do
      expect(domains_populated).not_to receive(:create)
      chef_run
    end

    it do
      expect(found_domain).to receive(:destroy)
      chef_run
    end
  end
end
