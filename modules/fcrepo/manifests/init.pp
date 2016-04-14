# == Class: fcrepo
#
# Fedora 4 management module to install and configure Fedora
#
# === Parameters
#
# [*user*]
#   Unix user that will own and manage the Fedora 4 repository directories,
#   file, and service.
#
# [*group*]
#   Unix group that will own and manage the Fedora 4 repository directories,
#   file, and service.
#
# [*user_profile*]
#   The absolute path to the user's shell profile file.  May be a system-wide
#   file.
#
# [*fcrepo_sandbox_home*]
#   The base directory where Fedora and its supporting infrastructure software
#   will be installed.
#
# [*fcrepo_datadir*]
#   Fedora 4 data directory.
#
# [*fcrepo_configdir*]
#   Fedora 4 config directory.
#
# [*fcrepo_repository_json*]
#   The location where the Fedora 4 repository.json configuration file can be found for 
#   download and installation.
#   Can be a puppet: file: or http(s): URI. 
#
# [*fcrepo_jgroups_fcrepo_tcp_xml*]
#   The location where the Fedora 4 jgroups.fcrepo.tcp.xml configuration file can be 
#   found for download and installation.
#   Can be a puppet: file: or http(s): URI. 
#
# [*fcrepo_infinispan_xml*]
#   The location where the Fedora 4 infinispan.xml configuration file can be found for 
#   download and installation.
#   Can be a puppet: file: or http(s): URI. 
#
# [*fcrepo_warsource*]
#   Location where the Fedora 4 war file can be found for download and installation into
#   tomcat. Can be a string containing a puppet://, http(s)://, or ftp:// URL.
#
# [*fcrepo_db_host*]
#   When using Fedora with MySQL or PostGres, this is the hostname of the database server.
#
# [*fcrepo_db_port*]
#   When using Fedora with MySQL or PostGres, this is the port number of the database 
#   server.
#
# [*fcrepo_db_username*]
#   When using Fedora with MySQL or PostGres, this is the database username.
#
# [*fcrepo_db_password*]
#   When using Fedora with MySQL or PostGres, this is the database password.
#
# [*java_homedir*]
#   The directory where Java has been installed (JAVA_HOME).
#
# [*tomcat_source*]
#   The location where the Tomcat .tar.gz source file can be found for download.
#
# [*tomcat_deploydir*]
#   The Tomcat base directory (CATALINA_HOME).
#
# [*tomcat_install_from_source*]
#   A boolean.
#   true  - means the tomcat installation will be down given the $tomcat_source file.
#   false - means that the tomcat installation will be done using the OS package.
#
# [*tomcat_http_port*]
#   The port that tomcat will be configured to listen on for http connections
#
# [*tomcat_ajp_port*]
#   The port that tomcat will be configured to listen for ajp connections
#
# [*tomcat_redirect_port*]
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
#
# === Variables
#
# None at this time.
#
# === Examples
#
#  class { fcrepo:
#    fcrepo_sandbox_home => '/opt/fcrepo',
#  }
#
# === Authors
#
# Scott Prater <sprater@gmail.com>
#
# === Copyright
#
# Copyright 2014 Scott Prater
#
class fcrepo (

  $user                = 'UNSET',
  $group               = 'UNSET',
  $user_profile        = 'UNSET',
  $fcrepo_sandbox_home = 'UNSET',
  $fcrepo_datadir      = 'UNSET',
  $fcrepo_configdir    = 'UNSET',
  $fcrepo_repository_json = 'UNSET',
  $fcrepo_jgroups_fcrepo_tcp_xml = 'UNSET',
  $fcrepo_infinispan_xml = 'UNSET',
  $fcrepo_warsource    = 'UNSET',
  $fcrepo_db_host      = 'UNSET',
  $fcrepo_db_port      = 'UNSET',
  $fcrepo_db_username  = 'UNSET',
  $fcrepo_db_password  = 'UNSET',
  $java_homedir        = 'UNSET',
  $tomcat_source       = 'UNSET',
  $tomcat_deploydir    = 'UNSET',
  $tomcat_install_from_source = 'UNSET',
  $tomcat_http_port    = 'UNSET',
  $tomcat_ajp_port     = 'UNSET',
  $tomcat_redirect_port = 'UNSET',
  $tomcat_catalina_opts_xmx = 'UNSET',
  $tomcat_catalina_opts_maxpermsize = 'UNSET',
  $tomcat_catalina_opts_multicastaddr = 'UNSET',
  
) {

  include stdlib
  include tomcat
  include fcrepo::params

  validate_string($fcrepo::params::user)
  validate_string($fcrepo::params::group)
  validate_absolute_path($fcrepo::params::user_profile)
  validate_absolute_path($fcrepo::params::fcrepo_sandbox_home)
  validate_absolute_path($fcrepo::params::fcrepo_datadir)
  validate_absolute_path($fcrepo::params::fcrepo_configdir)
  validate_string($fcrepo::params::fcrepo_repository_json)
  validate_string($fcrepo::params::fcrepo_jgroups_fcrepo_tcp_xml)
  validate_string($fcrepo::params::fcrepo_infinispan_xml)
  validate_re($fcrepo::params::fcrepo_warsource, '.war$',
    'The Fedora source file is not a war file.')
  validate_string($fcrepo::params::fcrepo_db_host)
  validate_integer($fcrepo::params::fcrepo_db_port)
  validate_string($fcrepo::params::fcrepo_db_username)
  validate_string($fcrepo::params::fcrepo_db_password)
  validate_absolute_path($fcrepo::params::java_homedir)
  validate_re($fcrepo::params::tomcat_source, '.tar.gz$',
    'The Tomcat source file is not a .tar.gz file.')
  validate_absolute_path($fcrepo::params::tomcat_deploydir)
  validate_bool($fcrepo::params::tomcat_install_from_source)
  validate_integer($fcrepo::params::tomcat_http_port)
  validate_integer($fcrepo::params::tomcat_ajp_port)
  validate_integer($fcrepo::params::tomcat_redirect_port)
  validate_string($fcrepo::params::tomcat_catalina_opts_xmx)
  validate_string($fcrepo::params::tomcat_catalina_opts_maxpermsize)
  validate_string($fcrepo::params::tomcat_catalina_opts_multicastaddr)

  $user_real = $user? {
    'UNSET' => $::fcrepo::params::user,
    default => $user,
  }

  $group_real = $group? {
    'UNSET' => $::fcrepo::params::group,
    default => $group,
  }

  $user_profile_real = $user_profile? {
    'UNSET' => $::fcrepo::params::user_profile,
    default => $user_profile,
  }

  $fcrepo_sandbox_home_real = $fcrepo_sandbox_home? {
    'UNSET' => $::fcrepo::params::fcrepo_sandbox_home,
    default => $fcrepo_sandbox_home,
  }

  $fcrepo_datadir_real = $fcrepo_datadir? {
    'UNSET' => $::fcrepo::params::fcrepo_datadir,
    default => $fcrepo_datadir,
  }

  $fcrepo_configdir_real = $fcrepo_configdir? {
    'UNSET' => $::fcrepo::params::fcrepo_configdir,
    default => $fcrepo_configdir,
  }
  
  $fcrepo_repository_json_real = $fcrepo_repository_json? {
    'UNSET' => $::fcrepo::params::fcrepo_repository_json,
    default => $fcrepo_repository_json,
  }
  
  $fcrepo_jgroups_fcrepo_tcp_xml_real = $fcrepo_jgroups_fcrepo_tcp_xml? {
    'UNSET' => $::fcrepo::params::fcrepo_jgroups_fcrepo_tcp_xml,
    default => $fcrepo_jgroups_fcrepo_tcp_xml,
  }
  
  $fcrepo_infinispan_xml_real = $fcrepo_infinispan_xml? {
    'UNSET' => $::fcrepo::params::fcrepo_infinispan_xml,
    default => $fcrepo_infinispan_xml,
  }

  $fcrepo_warsource_real = $fcrepo_warsource? {
    'UNSET' => $::fcrepo::params::fcrepo_warsource,
    default => $fcrepo_warsource,
  }

  $fcrepo_db_host_real = $fcrepo_db_host? {
    'UNSET' => $::fcrepo::params::fcrepo_db_host,
    default => $fcrepo_db_host,
  }

  $fcrepo_db_port_real = $fcrepo_db_port? {
    'UNSET' => $::fcrepo::params::fcrepo_db_port,
    default => $fcrepo_db_port,
  }

  $fcrepo_db_username_real = $fcrepo_db_username? {
    'UNSET' => $::fcrepo::params::fcrepo_db_username,
    default => $fcrepo_db_username,
  }

  $fcrepo_db_password_real = $fcrepo_db_password? {
    'UNSET' => $::fcrepo::params::fcrepo_db_password,
    default => $fcrepo_db_password,
  }

  $java_homedir_real = $java_homedir? {
    'UNSET' => $::fcrepo::params::java_homedir,
    default => $java_homedir,
  }

  $tomcat_source_real = $tomcat_source? {
    'UNSET' => $::fcrepo::params::tomcat_source,
    default => $tomcat_source,
  }

  $tomcat_deploydir_real = $tomcat_deploydir? {
    'UNSET' => $::fcrepo::params::tomcat_deploydir,
    default => $tomcat_deploydir,
  }
  
  $tomcat_install_from_source_real = $tomcat_install_from_source? {
    'UNSET' => $::fcrepo::params::tomcat_install_from_source,
    default => $tomcat_install_from_source,
  }

  $tomcat_http_port_real = $tomcat_http_port? {
    'UNSET' => $::fcrepo::params::tomcat_http_port,
    default => $tomcat_http_port,
  }
  
  $tomcat_ajp_port_real = $tomcat_ajp_port? {
    'UNSET' => $::fcrepo::params::tomcat_ajp_port,
    default => $tomcat_ajp_port,
  }
  
  $tomcat_redirect_port_real = $tomcat_redirect_port? {
    'UNSET' => $::fcrepo::params::tomcat_redirect_port,
    default => $tomcat_redirect_port,
  }

  $tomcat_catalina_opts_xmx_real = $tomcat_catalina_opts_xmx? {
    'UNSET' => $::fcrepo::params::tomcat_catalina_opts_xmx,
    default => $tomcat_catalina_opts_xmx,
  }
  
  $tomcat_catalina_opts_maxpermsize_real = $tomcat_catalina_opts_maxpermsize? {
    'UNSET' => $::fcrepo::params::tomcat_catalina_opts_maxpermsize,
    default => $tomcat_catalina_opts_maxpermsize,
  }
  
  $tomcat_catalina_opts_multicastaddr_real = $tomcat_catalina_opts_multicastaddr? {
    'UNSET' => $::fcrepo::params::tomcat_catalina_opts_multicastaddr,
    default => $tomcat_catalina_opts_multicastaddr,
  }
  

# Using the anchor containment pattern for backwards compatibility (< 3.4.0)
  anchor { 'fcrepo::begin': } ->
  class { '::fcrepo::install': } ->
  class { '::fcrepo::config': } ~>
#  class { '::fcrepo::service': } ->
  anchor { 'fcrepo::end': }
}
