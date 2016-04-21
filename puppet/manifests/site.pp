hiera_resources('resources', {})
hiera_include('classes')

# Purge all firewall rules not managed by Puppet
resources { 'firewall': purge => true }

# Set default PATH for exec resources
Exec { path => [ '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' ] }

# Disable deprecation warning by switching to the new behavior:
# https://docs.puppetlabs.com/puppet/3.6/reference/release_notes.html
Package {
  allow_virtual => true,
  require       => 'Class[apt::update]'
}

# Mimic pluginsync in masterless
file { $::settings::libdir:
  ensure  => directory,
  source  => 'puppet:///plugins',
  recurse => true,
  purge   => true,
  backup  => false
}
