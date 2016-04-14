# == Class: fcrepo::install
#
# Install the packages and software necessary to run Fedora
# Parameters are set in class fcrepo
#
# === Parameters
#
# [*user_real*]
#   Unix user that will own and manage the Fedora 4 repository directories,
#   file, and service.
#
# [*group_real*]
#   Unix group that will own and manage the Fedora 4 repository directories,
#   file, and service.
#
# [*user_profile_real*]
#   The absolute path to the user's shell profile file.  May be a system-wide
#   file.
#
# [*fcrepo_sandbox_home_real*]
#   The base directory where Fedora and its supporting infrastructure software
#   will be installed.
#
# [*fcrepo_datadir_real*]
#   Fedora 4 data directory.
#
# [*fcrepo_configdir_real*]
#   Fedora 4 config directory.
#
# [*fcrepo_repository_json_real*]
#   The location where the Fedora 4 repository.json configuration file can be found for 
#   download and installation.
#   Can be a puppet: file: or http(s): URI. 
#
# [*fcrepo_jgroups_fcrepo_tcp_xml_real*]
#   The location where the Fedora 4 jgroups.fcrepo.tcp.xml configuration file can be 
#   found for download and installation.
#   Can be a puppet: file: or http(s): URI. 
#
# [*fcrepo_infinispan_xml_real*]
#   The location where the Fedora 4 infinispan.xml configuration file can be found for 
#   download and installation.
#   Can be a puppet: file: or http(s): URI. 
#
# [*fcrepo_warsource_real*]
#   Location where the Fedora 4 war file can be found for download and installation into
#   tomcat. Can be a string containing a puppet://, http(s)://, or ftp:// URL.
#
# [*fcrepo_db_host_real*]
#   When using Fedora with MySQL or PostGres, this is the hostname of the database server.
#
# [*fcrepo_db_port_real*]
#   When using Fedora with MySQL or PostGres, this is the port number of the database 
#   server.
#
# [*fcrepo_db_username_real*]
#   When using Fedora with MySQL or PostGres, this is the database username.
#
# [*fcrepo_db_password_real*]
#   When using Fedora with MySQL or PostGres, this is the database password.
#
# [*java_homedir_real*]
#   The directory where Java has been installed (JAVA_HOME).
#
# [*tomcat_source_real*]
#   The location where the Tomcat .tar.gz source file can be found for download.
#
# [*tomcat_deploydir_real*]
#   The Tomcat base directory (CATALINA_HOME).
#
# [*tomcat_install_from_source_real*]
#   A boolean.
#   true  - means the tomcat installation will be down given the $tomcat_source file.
#   false - means that the tomcat installation will be done using the OS package.
#
# [*tomcat_http_port_real*]
#   The port that tomcat will be configured to listen on for http connections
#
# [*tomcat_ajp_port_real*]
#   The port that tomcat will be configured to listen for ajp connections
#
# [*tomcat_redirect_port_real*]
#   The port that tomcat will be configured for its redirection.
#
# [*tomcat_catalina_opts_xmx*]
#   The CATALINA_OPTS for setting the maximum tomcat memory size (-Xmx)
#
# [*tomcat_catalina_opts_maxpermsize*]
#   The CATALINA_OPTS for setting the max tomcat memory perm size (-XX:MaxPermSize=)
#
# [*tomcat_catalina_opts_multicastaddr*]
#   The CATALINA_OPTS for setting the max tomcat jgroups udp mcast address (-Djgroups.udp.mcast_addr=)
##

# === Variables
#
# === Examples
#
# === Authors
#
# Scott Prater <sprater@gmail.com>
#
# === Copyright
#
# Copyright 2014 Scott Prater
#
class fcrepo::install {

  include fcrepo

  #  Create the user and group
  group { $::fcrepo::group_real:
    ensure => present,
  }

  user { $::fcrepo::user_real:
    ensure     => present,
    gid        => $::fcrepo::group_real,
    shell      => '/bin/bash',
    home       => "/home/${::fcrepo::user_real}",
    managehome => true,
    require    => Group[$::fcrepo::group_real],
  }

  # Create the sandbox directory, data directory,
  # user home directory, and user profile
  file { $::fcrepo::fcrepo_sandbox_home_real:
    ensure  => directory,
    path    => $::fcrepo::fcrepo_sandbox_home_real,
    group   => $::fcrepo::group_real,
    owner   => $::fcrepo::user_real,
    mode    => '0755',
    require => [ Group[$::fcrepo::group_real], User[$::fcrepo::user_real] ]
  }

  file { $::fcrepo::fcrepo_datadir_real:
    ensure  => directory,
    path    => $::fcrepo::fcrepo_datadir_real,
    group   => $::fcrepo::group_real,
    owner   => $::fcrepo::user_real,
    mode    => '0755',
    require => [ Group[$::fcrepo::group_real], User[$::fcrepo::user_real] ]
  }

  file { "/home/${::fcrepo::user_real}":
    ensure  => directory,
    path    => "/home/${::fcrepo::user_real}",
    group   => $::fcrepo::group_real,
    owner   => $::fcrepo::user_real,
    mode    => '0755',
    require => [ Group[$::fcrepo::group_real], User[$::fcrepo::user_real] ]
  }

  file { $::fcrepo::user_profile_real:
    ensure  => file,
    content => "export JAVA_HOME=${::fcrepo::java_homedir_real}",
    path    => $::fcrepo::user_profile_real,
  }

  # Install the infrastructure software

  # Tomcat
  # Note: user and group can't yet be set reliably without an update to the puppetlabs/tomcat
  # code. It looks like this change is in Master, waiting for release 1.4.2 which should
  # solve this issue.
  tomcat::instance { 'tomcat-fcrepo':
    user                => $::fcrepo::user_real,
    group               => $::fcrepo::group_real,
    catalina_base       => $::fcrepo::tomcat_deploydir_real,
    catalina_home       => $::fcrepo::tomcat_deploydir_real,
    install_from_source => $::fcrepo::tomcat_install_from_source_real,
    package_name        => 'tomcat',
    source_url          => $::fcrepo::tomcat_source_real,
  }->
  tomcat::config::server { 'tomcat-fcrepo':
    catalina_base => $::fcrepo::tomcat_deploydir_real,
    port          => '8105',
  }->
  tomcat::config::server::connector { 'tomcat-fcrepo-http':
    catalina_base         => $::fcrepo::tomcat_deploydir_real,
    port                  => $::fcrepo::tomcat_http_port_real,
    protocol              => 'HTTP/1.1',
    additional_attributes => {
      'redirectPort' => $::fcrepo::tomcat_redirect_port_real,
    }
  }->
  tomcat::config::server::connector { 'tomcat-fcrepo-ajp':
    catalina_base         => $::fcrepo::tomcat_deploydir_real,
    port                  => $::fcrepo::tomcat_ajp_port_real,
    protocol              => 'HTTP/1.1',
    additional_attributes => {
      'redirectPort' => $::fcrepo::tomcat_redirect_port_real,
    }
  }->
  tomcat::war { 'fcrepo.war':
    catalina_base => $::fcrepo::tomcat_deploydir_real,
    app_base      => 'webapps',
    war_source    => $::fcrepo::fcrepo_warsource_real,
  }->
  tomcat::setenv::entry {'tomcat-fcrepo-catalina-opts':
    config_file => "${::fcrepo::tomcat_deploydir_real}/bin/setenv.sh",
    param       => 'CATALINA_OPTS',
    value       => "-Xmx${::fcrepo::tomcat_catalina_opts_xmx_real} -XX:MaxPermSize=${::fcrepo::tomcat_catalina_opts_maxpermsize_real} -Djava.net.preferIPv4Stack=true -Djgroups.udp.mcast_addr=${::fcrepo::tomcat_catalina_opts_multicastaddr_real} -Dfcrepo.modeshape.configuration=file://${::fcrepo::fcrepo_configdir_real}/repository.json -Dfcrepo.ispn.jgroups.configuration=${::fcrepo::fcrepo_configdir_real}/jgroups-fcrepo-tcp.xml -Dfcrepo.infinispan.cache_configuration=${::fcrepo::fcrepo_configdir_real}/infinispan.xml -Dfcrepo.ispn.mysql.host=${::fcrepo::fcrepo_db_host_real} -Dfcrepo.ispn.mysql.port=${::fcrepo::fcrepo_db_port_real} -Dfcrepo.ispn.mysql.username=${::fcrepo::fcrepo_db_username_real} -Dfcrepo.ispn.mysql.password=${::fcrepo::fcrepo_db_password_real} -Dfcrepo.ispn.postgresql.host=${::fcrepo::fcrepo_db_host_real} -Dfcrepo.ispn.postgresql.port=${::fcrepo::fcrepo_db_port_real} -Dfcrepo.ispn.postgresql.username=${::fcrepo::fcrepo_db_username_real} -Dfcrepo.ispn.postgresql.password=${::fcrepo::fcrepo_db_password_real} -Dfcrepo.home=${::fcrepo::fcrepo_datadir_real}/fcrepo",
    quote_char  => "\"",
  }
  tomcat::setenv::entry {'tomcat-fcrepo-java-home':
    config_file => "${::fcrepo::tomcat_deploydir_real}/bin/setenv.sh",
    param       => 'JAVA_HOME',
    value       => $::fcrepo::java_homedir_real,
    quote_char  => "\"",
  }


}
