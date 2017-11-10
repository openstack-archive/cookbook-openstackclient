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
require_relative '../libraries/openstack_user'

describe 'openstackclient_test::user' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(
      UBUNTU_OPTS.merge(step_into: ['openstack_user'])
    )
    runner.converge(described_recipe)
  end

  let(:users_empty) do
    double :user,
           create: true,
           destroy: true,
           find: nil
  end

  let(:found_user) do
    double :find,
           id: 4,
           destroy: true
  end

  let(:users_populated) do
    double :user,
           create: true,
           destroy: true,
           find: found_user
  end

  let(:found_role) do
    double :find,
           id: 3
  end

  let(:roles_populated) do
    double :role,
           find: found_role
  end

  let(:found_domain) do
    double :find,
           id: 5
  end

  let(:domains_populated) do
    double :domains,
           find: found_domain
  end

  let(:found_project) do
    double :find,
           id: 42,
           grant_role_to_user: true,
           revoke_role_from_user: true
  end

  let(:projects_populated) do
    double :projects,
           find: found_project
  end

  context 'no users defined' do
    let(:connection_dub) do
      double :fog_connection,
             users: users_empty,
             domains: domains_populated,
             roles: roles_populated,
             projects: projects_populated
    end

    before do
      allow_any_instance_of(OpenstackclientCookbook::OpenstackUser)
        .to receive(:connection).and_return(connection_dub)
    end

    it do
      expect(connection_dub).to receive(:users)
      chef_run
    end

    it do
      expect(connection_dub).to receive(:domains)
      chef_run
    end

    it do
      expect(connection_dub).to receive(:roles)
      chef_run
    end

    it do
      expect(connection_dub).to receive(:projects)
      chef_run
    end

    it do
      expect(chef_run).to create_openstack_user('myuser')
    end

    it do
      expect(chef_run).to delete_openstack_user('myuser')
    end

    it do
      expect(chef_run).to write_log(
        'User with name: "myuser" doesn\'t exist'
      )
    end

    it do
      expect(chef_run).not_to write_log(
        'User with name: "myuser" already exists'
      )
    end

    it do
      expect(users_empty).to receive(:create)
        .with(
          name: 'myuser',
          domain_id: 5,
          email: 'myemail',
          default_project_id: 42,
          password: 'mypassword'
        )
      chef_run
    end

    it do
      expect(found_user).not_to receive(:destroy)
      chef_run
    end
  end

  context 'users defined' do
    let(:connection_dub) do
      double :fog_connection,
             users: users_populated,
             domains: domains_populated,
             roles: roles_populated,
             projects: projects_populated,
             grant_domain_user_role: true,
             revoke_domain_user_role: true
    end

    before do
      allow_any_instance_of(OpenstackclientCookbook::OpenstackUser)
        .to receive(:connection).and_return(connection_dub)
    end

    it do
      expect(connection_dub).to receive(:users)
      chef_run
    end

    it do
      expect(connection_dub).to receive(:domains)
      chef_run
    end

    it do
      expect(connection_dub).to receive(:roles)
      chef_run
    end

    it do
      expect(connection_dub).to receive(:projects)
      chef_run
    end

    it do
      expect(chef_run).to create_openstack_user('myuser')
    end

    it do
      expect(chef_run).to delete_openstack_user('myuser')
    end

    it do
      expect(chef_run).not_to write_log(
        'User with name: "myuser" doesn\'t exist'
      )
    end

    it do
      expect(chef_run).to write_log(
        'User with name: "myuser" already exists'
      )
    end

    it do
      expect(chef_run).to grant_role_openstack_user('myuser')
    end

    it do
      expect(chef_run).to revoke_role_openstack_user('myuser')
    end

    it do
      expect(chef_run).to grant_domain_openstack_user('myuser')
    end

    it do
      expect(chef_run).to revoke_domain_openstack_user('myuser')
    end

    it do
      expect(users_empty).not_to receive(:create)
      chef_run
    end

    it do
      expect(found_user).to receive(:destroy)
      chef_run
    end

    it do
      expect(found_project).to receive(:grant_role_to_user)
        .with(3, 4)
      chef_run
    end

    it do
      expect(found_project).to receive(:revoke_role_from_user)
        .with(3, 4)
      chef_run
    end

    it do
      expect(connection_dub).to receive(:grant_domain_user_role)
        .with(5, 4, 3)
      chef_run
    end

    it do
      expect(connection_dub).to receive(:revoke_domain_user_role)
        .with(5, 4, 3)
      chef_run
    end
  end
end
