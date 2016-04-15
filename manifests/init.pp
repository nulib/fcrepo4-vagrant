# ########
# A vagrant box with Fedora 4 and MySQL
#
# This is the Puppet configuration for this vagrant machine.
# ########

# ###
# OpenJDK Java install from OS repo
# ###
package {'java-1.8.0-openjdk': ensure => 'installed',}

# ###
# Firewall configuration
# ###
firewalld_port { 'Open port 8080 in the public zone':
  ensure   => present,
  zone     => 'public',
  port     => 8080,
  protocol => 'tcp',
}

# ###
# Set up Fedora 4 and database based on storage type configuration in Vagrantfile
# (There is probably a better way to do this, but Puppet doesn't support changing
# variables in different scopes, which makes things harder.)
# ###
case $storagetype {
  'mysql':
  {
    ###
    # MySQL Configuration
    ###
    class { "mysql::server":
        root_password => 'KJN09f9jDSlkjsdfkj',
        remove_default_accounts => true,
    }
    include '::mysql::server'
    mysql::db { 'ispn':
        user     => 'fcrepouser',
        password => '34inasdfioHDSFIKSHio',
        host     => 'localhost',
        grant    => ['all'],
    } 
    ###
    # Fedora 4 Configuration
    ###
    class { '::fcrepo':
      user                => 'fcrepo',
      group               => 'fcrepo',
      user_profile        => '/home/fcrepo/.bashrc',
      tomcat_deploydir    => '/fedora/tomcat7',
      fcrepo_datadir      => '/data',
      fcrepo_configdir    => '/fedora/config',
      java_homedir        => '/usr/lib/jvm/jre-1.8.0',
      # These three lines are specific to the MySQL config:
      fcrepo_repository_json => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.5.1-RC-2/fcrepo-configs/src/main/resources/config/minimal-default/repository.json',
      fcrepo_infinispan_xml  => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.5.1-RC-2/fcrepo-configs/src/main/resources/config/infinispan/jdbc-mysql/infinispan.xml',
      fcrepo_db_port      => '3306',
      #
      fcrepo_jgroups_fcrepo_tcp_xml => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.5.1-RC-2/fcrepo-configs/src/main/resources/config/jgroups-fcrepo-tcp.xml',
      fcrepo_db_host      => 'localhost',
      fcrepo_db_username  => 'fcrepouser',
      fcrepo_db_password  => '34inasdfioHDSFIKSHio',
      tomcat_source       => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz',
      fcrepo_warsource    => 'https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-4.5.1-RC-2/fcrepo-webapp-4.5.1-RC-2.war',
    }->
    fcrepo::service { 'tomcat-fcrepo':
      service_enable      => true,
      service_ensure      => 'running',
    }
  }
  'postgresql':
  {
    # ###
    # PostGres Configuration
    # ###
    class { 'postgresql::server': 
      listen_addresses  => '*',
      postgres_password => 'afdg09jqa3490SDFGOin',
    }
    postgresql::server::db { 'ispn':
      user     => 'fcrepouser',
      password => postgresql_password('fcrepouser', 'akldsnf34SDKNDSoiwneiov'),
    }
    ###
    # Fedora 4 Configuration
    ###
    class { '::fcrepo':
      user                => 'fcrepo',
      group               => 'fcrepo',
      user_profile        => '/home/fcrepo/.bashrc',
      tomcat_deploydir    => '/fedora/tomcat7',
      fcrepo_datadir      => '/data',
      fcrepo_configdir    => '/fedora/config',
      java_homedir        => '/usr/lib/jvm/jre-1.8.0',
      # These three lines are needed for the PostgreSQL config:
      fcrepo_repository_json => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.5.1-RC-2/fcrepo-configs/src/main/resources/config/jdbc-postgresql/repository.json',
      fcrepo_infinispan_xml  => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.5.1-RC-2/fcrepo-configs/src/main/resources/config/infinispan/jdbc-postgresql/infinispan.xml',
      fcrepo_db_port      => '5432',
      #
      fcrepo_jgroups_fcrepo_tcp_xml => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.5.1-RC-2/fcrepo-configs/src/main/resources/config/jgroups-fcrepo-tcp.xml',
      fcrepo_db_host      => 'localhost',
      fcrepo_db_username  => 'fcrepouser',
      fcrepo_db_password  => 'akldsnf34SDKNDSoiwneiov',
      tomcat_source       => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz',
      fcrepo_warsource    => 'https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-4.5.1-RC-2/fcrepo-webapp-4.5.1-RC-2.war',
    }->
    fcrepo::service { 'tomcat-fcrepo':
      service_enable      => true,
      service_ensure      => 'running',
    }
  }
  'leveldb':
  {
    ###
    # Fedora 4 Configuration
    ###
    class { '::fcrepo':
      user                => 'fcrepo',
      group               => 'fcrepo',
      user_profile        => '/home/fcrepo/.bashrc',
      tomcat_deploydir    => '/fedora/tomcat7',
      fcrepo_datadir      => '/data',
      fcrepo_configdir    => '/fedora/config',
      java_homedir        => '/usr/lib/jvm/jre-1.8.0',
      # These two lines are specific to the LevelDB config:
      fcrepo_repository_json => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.5.1-RC-2/fcrepo-configs/src/main/resources/config/minimal-default/repository.json',
      fcrepo_infinispan_xml  => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.5.1-RC-2/fcrepo-configs/src/main/resources/config/infinispan/leveldb-default/infinispan.xml',
      #
      fcrepo_jgroups_fcrepo_tcp_xml => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.5.1-RC-2/fcrepo-configs/src/main/resources/config/jgroups-fcrepo-tcp.xml',
      tomcat_source       => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz',
      fcrepo_warsource    => 'https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-4.5.1-RC-2/fcrepo-webapp-4.5.1-RC-2.war',
    }->
    fcrepo::service { 'tomcat-fcrepo':
      service_enable      => true,
      service_ensure      => 'running',
    }
  }
}



