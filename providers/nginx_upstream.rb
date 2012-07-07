#
# Cookbook Name:: application_ruby
# Provider:: nginx_upstream
#
# Copyright 2012, Binary Marbles Trond Arve Nordheim
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include Chef::Mixin::LanguageIncludeRecipe

action :before_compile do

  include_recipe 'nginx'

  unless new_resource.server_aliases
    server_aliases = [ "#{new_resource.application.name}.#{node['domain']}", node['fqdn'] ]
    if node.has_key?("cloud")
      server_aliases << node['cloud']['public_hostname']
    end
    new_resource.server_aliases server_aliases
  end

  new_resource.restart_command "/etc/init.d/nginx restart"
  
end

action :before_deploy do

  new_resource = @new_resource

  # Write the Nginx configuration.
  template "/etc/nginx/sites-available/#{new_resource.application.name}.conf" do
    source new_resource.config_template || "#{new_resource.application.name}.conf.erb"
    cookbook new_resource.cookbook_name
    variables(
      :app => new_resource,
      :server_name => "#{new_resource.application.name}.#{node['domain']}"
    )
  end

  # Enable the Nginx config.
  nginx_site "#{new_resource.application.name}.conf"

  # Disable the default Nginx site.
  nginx_site 'default' do
    enable false
  end

end

action :before_migrate do
end

action :before_symlink do
end

action :before_restart do
end

action :after_restart do
end
