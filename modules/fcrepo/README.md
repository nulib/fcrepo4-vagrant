####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Prerequisites](#prerequisites)
3. [Setup - The basics of getting started with fcrepo](#setup)
    * [What fcrepo affects](#what-fcrepo-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with fcrepo](#beginning-with-fcrepo)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

The fcrepo module installs, configures, and manages Fedora 4 in a single or clustered 
environment.

##Module Description

The fcrepo module manages running Fedora 4 repositories in a single or a clustered 
environment.  The module installs Tomcat,
installs the Fedora WAR file and sets up the FCREPO_HOME directory. It can be used to manage 
the configuration files for every Fedora instance on each node in the cluster.

##Prerequisites

To use this module, you need:

1. Puppet installed (of course). This has been tested with Puppet 3.8.1. 
2. The following Puppet modules:
    * puppetlabs/stdlib
    * puppetlabs/tomcat
    Note: Version 1.4.1 available on puppetforge doesn't work correctly -- it only
    allows one user and group to be set per node. There is an update on github which fixes
    this issue. Use these commands to install puppetlabs/tomcat:
    ```
    wget "https://github.com/steve-didomenico/puppetlabs-tomcat/raw/ticket/MODULES-3117-user_and_group_per_instance_fix/pkg/puppetlabs-tomcat-1.4.1.tar.gz"
    ```
    And then to install:
    ```
    puppet module install /path/to/puppetlabs-tomcat-1.4.1.tar.gz --modulepath /path/to/modules
    ```
3. Java already installed on the machine. Usually this can be installed by doing one of 
   the following:
    * Setting up your OS's packaged Java via Puppet by putting something like this as 
    part of the init: 
    ```
    package {'java-1.8.0-openjdk': ensure => 'installed',}
    ```
    * Using the official puppetlabs/java module for Java installation, particularly if 
    you need multiple versions of Java installed. This should configure the proper path 
    to the Java installation.
    * Installing a package (such as Oracle's Java RPM), which also sets up the proper path.
    Installing this via a local yum repository can allow Puppet to easily install this 
    for your machines.

###Install and configure a base installation of Puppet

Puppet Labs has good step-by-step documentation for getting a Puppet master 
and Puppet clients set up.

Install:  <http://docs.puppetlabs.com/guides/installation.html>

Setup:  <http://docs.puppetlabs.com/guides/setting_up.html>

Make sure your agents can contact the master puppet server and receive their 
catalog information:

```sudo puppet agent --test```

###Common Puppet Setup Issues

 * Make sure hosts are all time synch'ed via NTP
 * Use lowercase hostnames, including DNS entries
 * Only install the version of Ruby that is required by the puppetmaster package (Ubuntu)
 * If your host uses a web proxy, include that directive in puppet.conf and also set environment variables. Both are required for module installation.

  
```
http_proxy_host=myproxy.example.com
http_proxy_port=3128
```

```
$ export https_proxy=http://myproxy.example.com:3128
$ export http_proxy=http://myproxy.example.com:3128
```

###Install the extra Puppet modules on your puppet master

```
sudo puppet module install puppetlabs/stdlib --modulepath /path/to/modules
sudo puppet module install puppetlabs/tomcat --modulepath /path/to/modules (note: see above about installing the correct version)
```

##Setup

###What fcrepo affects

* Fedora service user and group
* Tomcat standalone install
* Fedora WAR
* Fedora directories (home and data)
* Fedora configuration files
* Tomcat service

This module creates a user and group to manage the Fedora service and files,
creates a software directory and a data directory and assigns ownership of
them to the fedora user, then installs standalone versions of Tomcat.  
The module installs Fedora in a
sandboxed environment, with infrastructure software downloaded and
installed from binary distributions, and should work on any Unix environment.

It also deploys the Fedora WAR and Fedora configuration files,
and manages the Fedora Tomcat service.

###Beginning with fcrepo

####Build and install the module

1. Clone this project, change to the `puppet-fcrepo` directory. 

2. Build the module: 

```
    puppet module build .
```

3. Install the module:

```
    sudo puppet module install pkg/sprater-fcrepo-<version>.tar.gz --ignore-dependencies
```

   where `<version>` is the current version of the module.

####Enable the module in Puppet

`include 'fcrepo'` in the puppet master's `site.pp` file (located in manifests folder) is enough to get 
you up and running.  If you wish to pass in parameters such as which user and
group to create then you can use instead:                                                                                    

```puppet
class { '::fcrepo':
  user                => 'tomcat',
  group               => 'tomcat',
  user_profile        => '/home/tomcat/.bashrc',
  tomcat_deploydir    => '/fedora/tomcat7',
  fcrepo_sandbox_home => '/fedora',
  fcrepo_datadir      => '/fedora/data',
  fcrepo_configdir    => '/fedora/config',
}
```
Note: Placing the above include and class outside of specific node definitions, as above, will apply the fcrepo role to every puppet node. Alternately, place them within an appropriate node block.

And to startup the service, use:
```puppet
fcrepo::service { 'tomcat-fcrepo':
  service_enable      => true,
  service_ensure      => 'running',
}
```
A more advanced configuration (defining more than the defaults) would look like this:
```puppet
class { '::fcrepo':
  user                          => 'fcrepo',
  group                         => 'fcrepo',
  user_profile                  => '/home/fcrepo/.bashrc',
  tomcat_deploydir              => '/fedora/tomcat7',
  fcrepo_datadir                => '/data',
  fcrepo_sandbox_home           => '/fedora',
  fcrepo_configdir              => '/fedora/config',
  java_homedir                  => '/usr/java/default',
  fcrepo_repository_json        => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.4.0/fcrepo-configs/src/main/resources/config/minimal-default/repository.json',
  fcrepo_jgroups_fcrepo_tcp_xml => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.4.0/fcrepo-configs/src/main/resources/config/jgroups-fcrepo-tcp.xml',
  fcrepo_infinispan_xml         => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.4.0/fcrepo-configs/src/main/resources/config/infinispan/leveldb-default/infinispan.xml',
  tomcat_source                 => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz',
  fcrepo_warsource              => 'https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-4.4.0/fcrepo-webapp-4.4.0.war',
  tomcat_install_from_source    => true,
  tomcat_http_port              => '8080',
  tomcat_ajp_port               => '8009',
  tomcat_redirect_port          => '8443',
  tomcat_catalina_opts_xmx      => '1024m',
  tomcat_catalina_opts_maxpermsize => '256m',
}->fcrepo::service { 'tomcat-fcrepo':
  service_enable => true,
  service_ensure => 'running',
}
```

##Usage

##Reference

###Classes

####Public Classes

* fcrepo:  Main class, includes all other classes

####Private Classes

* fcrepo::install: Creates the user and group, ensures that the correct
  directories exist, and installs the base software and the Fedora WAR.
* fcrepo::config: Manages the configuration files.
* fcrepo::service: Manages the Tomcat service.

###Parameters

The following parameters are available in the fcrepo module.  They
are grouped into __Environment__, __Infrastructure__, and __Fedora__.

The defaults are defined in `fcrepo::params`, and may be changed there, or
overridden in the Puppet files that include the `fcrepo` class.

####Environment

#####`user`

The Unix user that will own the Fedora directories, software, and data.

Default: **fcrepo**

#####`group`

The Unix group that will own the Fedora directories, software, and data.

Default: **fcrepo**

#####`user_profile`

The absolute path to the shell profile file that should be modified to
update the PATH environment variable.  Can be set to a system-wide profile
(i.e. `/etc/profile`).

Default is **/home/_user_/.bashrc**

####Infrastructure

Software packages by default are installed in the Fedora 4 sandbox directory, owned
by the Fedora Unix user and group.  The user's PATH is modified to point first to 
these tools in the sandbox, and other environment variables may be set in the user's 
profile file.

#####`java_homedir`

The location where Java is installed; this variable is used to set JAVA_HOME. The default 
will attempt to use the Red Hat system Java location.

Default:  **/usr/java/default**

#####`tomcat_source`

The URL where Tomcat binary distribution package, can be found in *.tar.gz format.
The package will be automatically downloaded and installed.

Default:  **http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz**

#####`tomcat_deploydir`

The Tomcat base directory (CATALINA_HOME).

Default:  **_fcrepo sandbox home_/tomcat7**

#####`tomcat_install_from_source`

 A boolean which states whether the tomcat install should be done from a source .tar.gz file.
 * `true`  - means the tomcat installation will be down given the $tomcat_source file.
 * `false` - means that the tomcat installation will be done using the OS package.
 
Default: **true**

#####`tomcat_http_port`
   The port that tomcat will be configured to listen on for http connections.
   
Default: **8080**

#####`tomcat_ajp_port`
   The port that tomcat will be configured to listen for ajp connections
   
Default: **8009**

#####`tomcat_redirect_port`
   The port that tomcat will be configured for its redirection.

Default: **8443**

#####`tomcat_catalina_opts_xmx`
The CATALINA_OPTS for setting the maximum tomcat memory size (-Xmx)

Default: **1024m**

#####`tomcat_catalina_opts_maxpermsize`
The CATALINA_OPTS for setting the max tomcat memory perm size (-XX:MaxPermSize=)

Default: **256m**

#####`tomcat_catalina_opts_multicastaddr`
The CATALINA_OPTS for setting the max tomcat jgroups udp mcast address (-Djgroups.udp.mcast_addr=)

Default: **192.168.254.254**

#### Fedora

#####`fcrepo_sandbox_home`

The home directory for the Fedora environment sandbox.

Default: **/fedora**

#####`fcrepo_datadir`

The Fedora data directory.

Default: **/data**

#####`fcrepo_configdir`

The Fedora configuration directory.

Default: **/fedora/config**

#####`fcrepo_repository_json`

The location where the Fedora 3 repository.json configuration file can be found
for installation. Can be a puppet://, http(s)://, or ftp:// URL.
The config file will be installed into the fcrepo_configdir directory. Defaults to 
Fedora 4.4.0 configuration stored in github.

Note: The fcrepo Puppet module changes one line in the repository.json file, so the
location of the cacheConfiguration points to the local infinispan.xml file.

Default: **https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.4.0/fcrepo-configs/src/main/resources/config/minimal-default/repository.json**

#####`fcrepo_jgroups_fcrepo_tcp_xml`

The location where the Fedora 3 jgroups-fcrepo-tcp.xml configuration file can be found
for installation. Can be a puppet://, http(s)://, or ftp:// URL.
The config file will be installed into the fcrepo_configdir directory. Defaults to 
Fedora 4.4.0 configuration stored in github.

Default: **https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.4.0/fcrepo-configs/src/main/resources/config/jgroups-fcrepo-tcp.xml**

#####`fcrepo_infinispan_xml`

The location where the Fedora 3 infinispan.xml configuration file can be found
for installation. Can be a puppet://, http(s)://, or ftp:// URL.
The config file will be installed into the fcrepo_configdir directory. Defaults to 
Fedora 4.4.0 configuration stored in github.

Default: **https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.4.0/fcrepo-configs/src/main/resources/config/infinispan/leveldb-default/infinispan.xml**

#####`fcrepo_warsource`

The location where the Fedora 4 war file can be found for download.
Can be a puppet://, http(s)://, or ftp:// URL.
The warfile will be installed into Tomcat's webapps.

Default: **https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-4.4.0/fcrepo-webapp-4.4.0.war**

#####`fcrepo_db_host`

Optional. When using MySQL or Postgres (at the time of this writing, only prerelease versions of Fedora
after version 4.5.1), sets the hostname for the database connection.

Default: **localhost**

#####`fcrepo_db_port`

Optional. When using MySQL or Postgres, sets the port for the database connection.

Default: **3306**

#####`fcrepo_db_username`

Optional. When using MySQL or Postgres, sets the username for the database connection.

Default: **fcrepouser**

#####`fcrepo_db_password`

Optional. When using MySQL or Postgres, sets the password for the database connection.

Default: **changeme**


##Limitations

This module does not define the raw filesystem devices, nor mount
any filesystems.  Make sure the filesystem(s) in which the sandbox
and data directories will reside are created and mounted.

This module does not set a password for the Fedora Unix user.  You'll
need to do that yourself.

##Development

See the [DEVELOPERS](DEVELOPERS.md) file for more information on modifying, 
testing, and building this module.
