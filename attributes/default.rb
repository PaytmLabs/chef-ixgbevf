
default['ixgbevf']['version'] = "3.2.2"
default['ixgbevf']['checksum'] = '882534144078e8f7c856f99aae387cf181b1c75fb01fb2ba06299cd3f6f0d9c4'
default['ixgbevf']['package'] = "ixgbevf-#{node['ixgbevf']['version']}.tar.gz"
default['ixgbevf']['package_url'] = "http://sourceforge.net/projects/e1000/files/ixgbevf%20stable/#{node['ixgbevf']['version']}/#{node['ixgbevf']['package']}"
default['ixgbevf']['dir']     = "/usr/src/ixgbevf-#{node['ixgbevf']['version']}"
default['ixgbevf']['module_flags'] = "InterruptThrottleRate=1,1,1,1,1,1,1,1"
default['ixgbevf']['disable_ifnames'] = false
default['ixgbevf']['compile_time'] = true
default['ixgbevf']['dkms_dir'] = '/var/lib/dkms/ixgbevf'
default['ixgbevf']['restart_module'] = false

case node['platform']
  when 'ubuntu'
    if node['platform_version'].to_f >= 14.04
      default['ixgbevf']['disable_ifnames'] = true
    end
  when 'debian'
    if node['platform_version'].to_f >= 8.0
      default['ixgbevf']['disable_ifnames'] = true
    end
  when 'centos', 'rhel'
    if node['platform_version'].to_f >= 7.0
      default['ixgbevf']['disable_ifnames'] = true
    end
end

