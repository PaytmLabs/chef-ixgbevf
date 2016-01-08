name             'ixgbevf'
maintainer       'Joe Hohertz'
maintainer_email 'jhohertz@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures ixgbevf'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

depends          'yum-epel', '>= 0.0.0'
depends          'apt', '>= 0.0.0'

%w(ubuntu centos redhat debian).each do |os|
  supports os
end
