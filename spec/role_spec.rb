
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

require 'spec_helper'
require_relative '../libraries/openstack_role'

describe 'openstackclient_test::role' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(
      UBUNTU_OPTS.merge(step_into: ['openstack_role'])
    )
    runner.converge(described_recipe)
  end

  let(:roles_empty) do
    double :role,
           create: true,
           destroy: true,
           find: nil
  end

  let(:found_role) do
    double :find,
           destroy: true
  end

  let(:roles_populated) do
    double :role,
           create: true,
           destroy: true,
           find: found_role
  end

  context 'no roles defined' do
    let(:connection_dub) do
      double :fog_connection,
             roles: roles_empty
    end

    before do
      allow_any_instance_of(OpenstackclientCookbook::OpenstackRole)
        .to receive(:connection).and_return(connection_dub)
    end

    it do
      expect(connection_dub).to receive(:roles)
      chef_run
    end

    it do
      expect(chef_run).to create_openstack_role('myrole')
    end

    it do
      expect(chef_run).to delete_openstack_role('myrole')
    end

    it do
      expect(roles_empty).to receive(:create)
        .with(
          name: 'myrole'
        )
      chef_run
    end

    it do
      expect(found_role).not_to receive(:destroy)
      chef_run
    end
  end

  context 'roles defined' do
    let(:connection_dub) do
      double :fog_connection,
             roles: roles_populated
    end

    before do
      allow_any_instance_of(OpenstackclientCookbook::OpenstackRole)
        .to receive(:connection).and_return(connection_dub)
    end

    it do
      expect(connection_dub).to receive(:roles)
      chef_run
    end

    it do
      expect(chef_run).to create_openstack_role('myrole')
    end

    it do
      expect(chef_run).to delete_openstack_role('myrole')
    end

    it do
      expect(roles_empty).not_to receive(:create)
      chef_run
    end

    it do
      expect(found_role).to receive(:destroy)
      chef_run
    end
  end
end
