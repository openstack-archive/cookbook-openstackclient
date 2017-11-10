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
require_relative '../libraries/openstack_project'

describe 'openstackclient_test::project' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(
      UBUNTU_OPTS.merge(step_into: ['openstack_project'])
    )
    runner.converge(described_recipe)
  end

  let(:projects_empty) do
    double :projects,
           create: true,
           destroy: true,
           find: nil
  end

  let(:found_project) do
    double :find,
           destroy: true
  end

  let(:projects_populated) do
    double :projects,
           create: true,
           destroy: true,
           find: found_project
  end

  context 'no projects defined' do
    let(:connection_dub) do
      double :fog_connection,
             projects: projects_empty
    end

    before do
      allow_any_instance_of(OpenstackclientCookbook::OpenstackProject)
        .to receive(:connection).and_return(connection_dub)
    end

    it do
      expect(connection_dub).to receive(:projects)
      chef_run
    end

    it do
      expect(chef_run).to create_openstack_project('myproject')
    end

    it do
      expect(chef_run).to delete_openstack_project('myproject')
    end

    it do
      expect(chef_run).to write_log(
        'Project with name: "myproject" doesn\'t exist'
      )
    end

    it do
      expect(chef_run).not_to write_log(
        'Project with name: "myproject" already exists'
      )
    end

    it do
      expect(projects_empty).to receive(:create)
        .with(
          name: 'myproject'
        )
      chef_run
    end

    it do
      expect(found_project).not_to receive(:destroy)
      chef_run
    end
  end

  context 'projects defined' do
    let(:connection_dub) do
      double :fog_connection,
             projects: projects_populated
    end

    before do
      allow_any_instance_of(OpenstackclientCookbook::OpenstackProject)
        .to receive(:connection).and_return(connection_dub)
    end

    it do
      expect(connection_dub).to receive(:projects)
      chef_run
    end

    it do
      expect(chef_run).to create_openstack_project('myproject')
    end

    it do
      expect(chef_run).to delete_openstack_project('myproject')
    end

    it do
      expect(chef_run).not_to write_log(
        'Project with name: "myproject" doesn\'t exist'
      )
    end

    it do
      expect(chef_run).to write_log(
        'Project with name: "myproject" already exists'
      )
    end

    it do
      expect(projects_empty).not_to receive(:create)
      chef_run
    end

    it do
      expect(found_project).to receive(:destroy)
      chef_run
    end
  end
end
