
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

if defined?(ChefSpec)
  def create_openstack_project(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:openstack_project, :create, resource_name)
  end

  def delete_openstack_project(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:openstack_project, :delete, resource_name)
  end

  def create_openstack_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:openstack_service, :create, resource_name)
  end

  def delete_openstack_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:openstack_service, :delete, resource_name)
  end

  def create_openstack_endpoint(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:openstack_endpoint, :create, resource_name)
  end

  def delete_openstack_endpoint(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:openstack_endpoint, :delete, resource_name)
  end

  def create_openstack_role(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:openstack_role, :create, resource_name)
  end

  def delete_openstack_role(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:openstack_role, :delete, resource_name)
  end

  def create_openstack_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:openstack_user, :create, resource_name)
  end

  def delete_openstack_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:openstack_user, :delete, resource_name)
  end

  def grant_role_openstack_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:openstack_user, :grant_role, resource_name)
  end

  def revoke_role_openstack_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:openstack_user, :revoke_role, resource_name)
  end

  def grant_domain_openstack_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:openstack_user, :grant_domain, resource_name)
  end

  def revoke_domain_openstack_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:openstack_user, :revoke_domain, resource_name)
  end

  def create_openstack_domain(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:openstack_domain, :create, resource_name)
  end

  def delete_openstack_domain(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:openstack_domain, :delete, resource_name)
  end
end
