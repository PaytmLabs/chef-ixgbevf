#
# Cookbook Name:: ixgbevf
# Recipe:: default
#
# Copyright (C) 2015 Joe Hohertz
#

include_recipe 'ixgbevf::dkms'
include_recipe 'ixgbevf::ifnames_disable' if node['ixgbevf']['disable_ifnames']

package 'patch'

remote_file "#{Chef::Config[:file_cache_path]}/#{node['ixgbevf']['package']}" do
  source node['ixgbevf']['package_url']
  checksum checksum
  mode 00644
  action :create
end

execute 'extract_ixgbevf_source' do
  command "tar xzvf #{Chef::Config[:file_cache_path]}/#{node['ixgbevf']['package']}"
  cwd '/usr/src'
  not_if { File.exists?( node['ixgbevf']['dir'] ) }
end

execute 'patch_ixgbevf_source' do
  command "patch -p1 < /usr/src/ixgbevf-vlan-tx.patch"
  cwd node['ixgbevf']['dir']
  not_if { File.exists?( "#{node['ixgbevf']['dir']}/src/kcompat.h.orig" ) }
  action :nothing
end

cookbook_file '/usr/src/ixgbevf-vlan-tx.patch' do
  source 'ixgbevf-vlan-tx.patch'
  owner 'root'
  group node['root_group']
  mode '0644'
  action :create
  notifies :run, 'execute[patch_ixgbevf_source]', :immediately
end

template "#{node['ixgbevf']['dir']}/dkms.conf" do
  source "dkms.conf.erb"
  owner "root"
  group "root"
  mode  00644
end

template "/etc/modprobe.d/ixgbevf.conf" do
  source "ixgbevf.conf.erb"
  owner "root"
  group "root"
  mode  00644
end

execute 'dkms_add_ixgbevf' do
  command "dkms add -m ixgbevf -v #{node['ixgbevf']['version']}"
  # FIXME: does this vary by platform?
  not_if { File.exists?( '/var/lib/dkms/ixgbevf' ) }
end

execute 'dkms_build_ixgbevf' do
  command "dkms build -m ixgbevf -v #{node['ixgbevf']['version']}"
end

execute 'dkms_install_ixgbevf' do
  command "dkms install -m ixgbevf -v #{node['ixgbevf']['version']}"
end



