# Description

Installs the fog-openstack gem and offers Resources to use it.

# Requirements

- gem 'fog-openstack'

# Resources

## openstack_domain
- creates or deletes an openstack domain
- example recipe can be found
  [here](spec/cookbooks/openstackclient_test/recipes/domain.rb)

## openstack_endpoint
- creates or deletes an openstack endpoint
- example recipe can be found
  [here](spec/cookbooks/openstackclient_test/recipes/endpoint.rb)

## openstack_project
- creates or deletes an openstack project
- example recipe can be found
  [here](spec/cookbooks/openstackclient_test/recipes/project.rb)

## openstack_role
- creates or deletes an openstack role
- example recipe can be found
  [here](spec/cookbooks/openstackclient_test/recipes/role.rb)

## openstack_service
- creates or deletes an openstack service
- example recipe can be found
  [here](spec/cookbooks/openstackclient_test/recipes/service.rb)

## openstack_user
- creates or deletes an openstack user
- grants or revokes role to user in project
- grants or revokes domain to user
- example recipe can be found
  [here](spec/cookbooks/openstackclient_test/recipes/user.rb)

# License and Maintainer

Maintainer:: cloudbau GmbH (<j.klare@cloudbau.de>)  
Source:: https://github.com/cloudbau/cookbook-openstackclient  
Issues:: https://github.com/cloudbau/cookbook-openstackclient/issues

License:: Apache v2.0
