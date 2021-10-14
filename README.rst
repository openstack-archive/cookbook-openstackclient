OpenStack Chef Cookbook - openstackclient
=========================================

.. image:: https://governance.openstack.org/badges/cookbook-openstackclient.svg
    :target: https://governance.openstack.org/reference/tags/index.html

Description
===========

Installs the ``fog-openstack`` gem and offers custom resources to use
it.

Requirements
============

- Chef 16 or higher
- Chef Workstation 21.10.640 for testing (also includes Berkshelf for
  cookbook dependency resolution)
- gem 'fog-openstack'

Resources
=========

openstack_domain
----------------

- creates or deletes an openstack domain
- example recipe can be found
  `here <cookbook-openstackclient/src/branch/master/spec/cookbooks/openstackclient_test/recipes/domain.rb>`__

openstack_endpoint
------------------

- creates or deletes an openstack endpoint
- example recipe can be found
  `here <cookbook-openstackclient/src/branch/master/spec/cookbooks/openstackclient_test/recipes/endpoint.rb>`__

openstack_project
-----------------

- creates or deletes an openstack project
- example recipe can be found
  `here <cookbook-openstackclient/src/branch/master/spec/cookbooks/openstackclient_test/recipes/project.rb>`__

openstack_role
--------------

- creates or deletes an openstack role
- example recipe can be found
  `here <cookbook-openstackclient/src/branch/master/spec/cookbooks/openstackclient_test/recipes/role.rb>`__

openstack_service
-----------------

- creates or deletes an openstack service
- example recipe can be found
  `here <cookbook-openstackclient/src/branch/master/spec/cookbooks/openstackclient_test/recipes/service.rb>`__

openstack_user
--------------

- creates or deletes an openstack user
- grants or revokes role to user in project
- grants or revokes domain to user
- example recipe can be found
  `here <cookbook-openstackclient/src/branch/master/spec/cookbooks/openstackclient_test/recipes/user.rb>`__

License and Author
==================

+-----------------+---------------------------------------------------+
| **Author**      | Jan Klare (j.klare@x-ion.de)                      |
+-----------------+---------------------------------------------------+
| **Author**      | Lance Albertson (lance@osuosl.org)                |
+-----------------+---------------------------------------------------+

+-----------------+---------------------------------------------------+
| **Copyright**   | Copyright (c) 2016-2018, cloudbau GmbH            |
+-----------------+---------------------------------------------------+
| **Copyright**   | Copyright (c) 2016-2019, x-ion GmbH               |
+-----------------+---------------------------------------------------+
| **Copyright**   | Copyright (c) 2019-2021, Oregon State University  |
+-----------------+---------------------------------------------------+

Licensed under the Apache License, Version 2.0 (the "License"); you may
not use this file except in compliance with the License. You may obtain
a copy of the License at

::

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
