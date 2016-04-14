# == Class: fcrepo::params
#
# Configuration parameters for the fcrepo module
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
class fcrepo::params {

    # Note: user and group have to be set using the tomcat class in the user's nodes.pp
    # Puppet configuration for tomcat, at least until an updated version of Puppetlabs
    # Tomcat has been released.
    $user                = 'fcrepo'
    $group               = 'fcrepo'
    $user_profile        = '/home/fcrepo/.bashrc'
    $fcrepo_sandbox_home = '/fedora'
    $fcrepo_datadir      = '/data'
    $fcrepo_configdir    = '/fedora/config'
    $fcrepo_repository_json = 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.4.0/fcrepo-configs/src/main/resources/config/minimal-default/repository.json'
    $fcrepo_jgroups_fcrepo_tcp_xml = 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.4.0/fcrepo-configs/src/main/resources/config/jgroups-fcrepo-tcp.xml'
    $fcrepo_infinispan_xml = 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.4.0/fcrepo-configs/src/main/resources/config/infinispan/leveldb-default/infinispan.xml'
    $fcrepo_warsource    = 'https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-4.4.0/fcrepo-webapp-4.4.0.war'
    $fcrepo_db_host      = 'localhost'
    $fcrepo_db_port      = '3306'
    $fcrepo_db_username  = 'fcrepouser'
    $fcrepo_db_password  = 'changeme'
    $java_homedir        = '/usr/java/default'
    $tomcat_source       = 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz'
    $tomcat_deploydir    = '/fedora/tomcat7'
    $tomcat_install_from_source = true
    $tomcat_http_port    = '8080'
    $tomcat_ajp_port     = '8009'
    $tomcat_redirect_port = '8443'
    $tomcat_catalina_opts_xmx = '1024m'
    $tomcat_catalina_opts_maxpermsize = '256m'
    $tomcat_catalina_opts_multicastaddr = '192.168.254.254'
}
