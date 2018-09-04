name 'openstackclient'
maintainer 'OpenStack'
maintainer_email 'openstack-dev@lists.openstack.org'
license 'Apache-2.0'
description 'Installs the fog-openstack gem and offers LWRPs to use it'
issues_url 'https://launchpad.net/openstack-chef'
source_url 'https://git.openstack.org/openstack/cookbook-openstack-client'
chef_version '>= 12.5' if respond_to?(:chef_version)
version '17.0.1'

%w(ubuntu redhat centos).each do |os|
  supports os
end

gem 'fog-openstack', '>=0.2.1'
