# Introduction

This contains a LAMP stack in a Vagrant box.

# Requirements

You need a recent Vagrant install (>= 1.7.0).

# Installation instructions

```
vagrant up
```

This will create a basic LAMP stack.

Apache is reachable from the host on port `8080`:

[http://localhost:8080](http://localhost:8080)

Mailcatcher is installed and PHP is configured to use it.
The Mailcatcher web interface is available at:

[http://localhost:1080](http://localhost:1080)

MySQL is also available from the host on port `3306`,
with user `vagrant`, password `vagrant`.
You can re-use this user for extra databases you create.

The directory `sites` on the host is an NFS synced folder to `/var/www/sites` in the box.
Any websites you drop in there will be available in the box under that directory.
You will need to add the correct information for extra Virtualhosts in Hiera (see below).

# Usage

There is 1 Apache Virtualhost configured (example.dev), and 1 MySQL database (example).
Adding extra sites or databases requires adding the correct stanzas to `puppet/hieradata/common.yaml`.

After adding the necessary information to Hiera, just run:

```
vagrant provision
```

This will create the necessary configuration in Apache and/or MySQL and restart the services.

Ensure any domain name ending with .dev points to 127.0.0.1 by using dnsmasq, or
add the following entry to your /etc/hosts file:

```
127.0.0.1 example.dev
```

Now visit the (empty) example site in your web browser at:

[http://example.dev:8080](http://example.dev:8080)
