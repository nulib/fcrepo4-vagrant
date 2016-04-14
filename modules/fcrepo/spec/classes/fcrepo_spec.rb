# spec/classes/fcrepo_spec.pp

require 'spec_helper'

describe 'fcrepo' do

  let :facts do
    {
      :osfamily => 'RedHat',
      :hostname => 'FedoraTestNode',
      :augeasversion => '1.0.0',
      :path     => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
    }
    
  end

  it { should compile.with_all_deps }

  it 'includes stdlib' do
    should contain_class('stdlib')
  end

  it 'includes tomcat' do
    should contain_class('tomcat')
  end

  it { should contain_class('fcrepo') }
  it { should contain_class('fcrepo::install') }
  it { should contain_class('fcrepo::config') }

  # Test group
  context "With no group specified" do
    it {
      should contain_group('fcrepo').with( { 'ensure' => 'present' } )
    }
  end

  context "With group specified" do
    let :params do
      {
        :group => 'fedora'
      }
    end
    it {
      should contain_group('fedora').with( { 'ensure' => 'present' } )
    }
  end

  # Test user
  context "With no user specified" do
    it {
      should contain_user('fcrepo').with( {
        'ensure'     => 'present',
        'gid'        => 'fcrepo',
        'shell'      => '/bin/bash',
        'home'       => '/home/fcrepo',
        'managehome' => true,
      } )
    }

    it {
      should contain_file('/home/fcrepo/.bashrc')
    }

  end

  context "With user specified" do
    let :params do
      {
        :user         => 'fedora',
        :user_profile => '/home/fedora/.bashrc'
      }
    end
    it {
      should contain_user('fedora').with( {
        'ensure'     => 'present',
        'gid'        => 'fcrepo',
        'shell'      => '/bin/bash',
        'home'       => '/home/fedora',
        'managehome' => true,
      } )
    }

    it {
      should contain_file('/home/fedora/.bashrc')
    }

  end

  context "With user and group specified" do
    let :params do
      {
        :user   => 'fedora',
        :group  => 'fedora',
      }
    end
    it {
      should contain_user('fedora').with( {
        'ensure'     => 'present',
        'gid'        => 'fedora',
        'shell'      => '/bin/bash',
        'home'       => '/home/fedora',
        'managehome' => true,
      } )
    }

  end

  # Test sandbox home
  context "With no sandbox directory specified" do
    it {
      should contain_file('/fedora').with( {
        'ensure'  => 'directory',
        'path'    => '/fedora',
        'group'   => 'fcrepo',
        'owner'   => 'fcrepo',
        'mode'    => '0755',
      } )
    }
  end

  context "With sandbox directory specified" do
    let :params do
      {
        :fcrepo_sandbox_home => '/opt/fedora',
        :user                => 'drwho'
      }
    end
    it {
      should contain_file('/opt/fedora').with( {
        'ensure'  => 'directory',
        'path'    => '/opt/fedora',
        'group'   => 'fcrepo',
        'owner'   => 'drwho',
        'mode'    => '0755',
      } )
    }
  end
  
  # Test Java home
  context "With Java home specified" do
    let :params do
      {
        :user                => 'drwho',
        :user_profile        => '/home/drwho/.bashrc',
        :java_homedir        => '/usr/local/java'

      }
    end
    it {
      should contain_file('/home/drwho/.bashrc').with_content(
        /^.*?export JAVA_HOME=\/usr\/local\/java.*?$/
      )
    }
  end

  # Test data directory home
  context "With no data directory specified" do
    it {
      should contain_file('/data').with( {
        'ensure'  => 'directory',
        'path'    => '/data',
        'group'   => 'fcrepo',
        'owner'   => 'fcrepo',
        'mode'    => '0755',
      } )
    }
  end

  context "With data directory specified" do
    let :params do
      {
        :fcrepo_datadir => '/opt/fedora/data',
        :user           => 'sholmes'
      }
    end
    it {
      should contain_file('/opt/fedora/data').with( {
        'ensure'  => 'directory',
        'path'    => '/opt/fedora/data',
        'group'   => 'fcrepo',
        'owner'   => 'sholmes',
        'mode'    => '0755',
      } )
    }
  end
 
  # Test Fedora config directory
  context "With no Fedora config directory specified" do
    it {
      should contain_file('/fedora/config').with( {
        'ensure'  => 'directory',
        'path'    => '/fedora/config',
        'group'   => 'fcrepo',
        'owner'   => 'fcrepo',
        'mode'    => '0755',
      } )
    }
  end

  context "With Fedora config directory specified" do
    let :params do
      {
        :fcrepo_configdir => '/opt/fedora/config',
        :user           => 'sholmes'
      }
    end
    it {
      should contain_file('/opt/fedora/config').with( {
        'ensure'  => 'directory',
        'path'    => '/opt/fedora/config',
        'group'   => 'fcrepo',
        'owner'   => 'sholmes',
        'mode'    => '0755',
      } )
    }
  end

  # With user home directory
  context "With unspecified user's home directory" do
    it {
      should contain_file('/home/fcrepo').with( {
        'ensure'  => 'directory',
        'path'    => '/home/fcrepo',
        'group'   => 'fcrepo',
        'owner'   => 'fcrepo',
        'mode'    => '0755',
      } )
    } 
  end

  context "With specified user's home directory" do
    let :params do
      {
        :user           => 'sholmes'
      }
    end
    it {
      should contain_file('/home/sholmes').with( {
        'ensure'  => 'directory',
        'path'    => '/home/sholmes',
        'group'   => 'fcrepo',
        'owner'   => 'sholmes',
        'mode'    => '0755',
      } )
    }
  end

  # Test Tomcat install
  context "With default tomcat_source and tomcat_deploydir" do
    it {
      should contain_tomcat__instance('tomcat-fcrepo').with( {
          'user'                => 'fcrepo',
          'group'               => 'fcrepo',
          'catalina_base'       => '/fedora/tomcat7',
          'install_from_source' => true,
          'package_name'        => 'tomcat',
          'source_url'          => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz',
      } )
    }
  end

  context "With specified tomcat_source and default tomcat_deploydir" do
    let :params do
      {
        :tomcat_source    => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.67/bin/apache-tomcat-7.0.67.tar.gz',
        :tomcat_install_from_source => true,
      }
    end
    it {
      should contain_tomcat__instance('tomcat-fcrepo').with( {
        'user'                       => 'fcrepo',
        'group'                      => 'fcrepo',
        'catalina_base'              => '/fedora/tomcat7',
        'install_from_source'        => true,
        'package_name'               => 'tomcat',
        'source_url'                 => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.67/bin/apache-tomcat-7.0.67.tar.gz',
      } )
    }
  end

  context "With specified tomcat_source and specified tomcat_deploydir" do
    let :params do
      {
        :tomcat_source    => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.67/bin/apache-tomcat-7.0.67.tar.gz',
        :tomcat_deploydir => '/opt/tomcat/tomcat7',
        :tomcat_install_from_source => true,
      }
    end
    it {
      should contain_tomcat__instance('tomcat-fcrepo').with( {
        'user'                       => 'fcrepo',
        'group'                      => 'fcrepo',
        'catalina_base'              => '/opt/tomcat/tomcat7',
        'install_from_source'        => true,
        'package_name'               => 'tomcat',
        'source_url'                 => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.67/bin/apache-tomcat-7.0.67.tar.gz',
      } )
    }
  end

  # Test Fedora 4 WAR install default source
  context "With Fedora 4 WAR default source" do
    it {
      should contain_tomcat__war('fcrepo.war').with( {
        'catalina_base'         => '/fedora/tomcat7',
        'app_base'              => 'webapps',
        'war_source'            => 'https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-4.4.0/fcrepo-webapp-4.4.0.war',
      } )
    }
  end

  # Test Fedora 4 WAR install custom source
  context "With Fedora 4 WAR custom source" do
    let :params do
      {
        :fcrepo_warsource    => 'https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-4.3.0/fcrepo-webapp-4.3.0.war',
      }
    end
    it {
      should contain_tomcat__war('fcrepo.war').with( {
        'catalina_base'         => '/fedora/tomcat7',
        'app_base'              => 'webapps',
        'war_source'            => 'https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-4.3.0/fcrepo-webapp-4.3.0.war',
      } )
    }
  end

  # Test Tomcat http connector port with default
  context "With Tomcat http connector port with default" do
    it {
      should contain_tomcat__config__server__connector('tomcat-fcrepo-http').with( {
        'catalina_base'         => '/fedora/tomcat7',
        'port'                  => '8080',
        'additional_attributes' => {'redirectPort' => '8443'},
      } )
    }
 end

  # Test Tomcat http connector port with custom port
  context "With Tomcat http connector with custom ports" do
      let :params do
      {
        :tomcat_http_port     => '8090',
        :tomcat_redirect_port => '8993',
      }
    end
    it {
      should contain_tomcat__config__server__connector('tomcat-fcrepo-http').with( {
        'catalina_base'         => '/fedora/tomcat7',
        'port'                  => '8090',
        'additional_attributes' => {'redirectPort' => '8993'},
      } )
    }
 end
 
   # Test Tomcat ajp connector port with default
  context "With Tomcat ajp connector port with default" do
    it {
      should contain_tomcat__config__server__connector('tomcat-fcrepo-ajp').with( {
        'catalina_base'         => '/fedora/tomcat7',
        'port'                  => '8009',
        'additional_attributes' => {'redirectPort' => '8443'},
      } )
    }
 end
 
   # Test Tomcat ajp connector port with custom port
  context "With Tomcat ajp connector with custom ports" do
      let :params do
      {
        :tomcat_ajp_port      => '8109',
        :tomcat_redirect_port => '8993',
      }
    end
    it {
      should contain_tomcat__config__server__connector('tomcat-fcrepo-ajp').with( {
        'catalina_base'         => '/fedora/tomcat7',
        'port'                  => '8109',
        'additional_attributes' => {'redirectPort' => '8993'},
      } )
    }
 end

  # Test Tomcat setenv.sh
  context "With setenv.sh template" do
    it {
      should contain_concat__fragment('setenv-tomcat-fcrepo-catalina-opts').with( {
        'ensure'    => 'present',
        'target'    => '/fedora/tomcat7/bin/setenv.sh',
        'content'   => /fedora\/config/,
      } )
    }
  end

  # Test default Fedora config repository.json
  context "With default Fedora config repository.json" do
    it {
      should contain_file('/fedora/config/repository.json').with( {
        'ensure'  => 'present',
        'path'    => '/fedora/config/repository.json',
        'group'   => 'fcrepo',
        'owner'   => 'fcrepo',
        'mode'    => '0644',
      } )
    }
    it {
      should contain_staging__file('repository.json').with( {
        'target'  => '/fedora/config/repository.json',
        'source'  => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.4.0/fcrepo-configs/src/main/resources/config/minimal-default/repository.json',
      } )
    }
    it {
      should contain_exec('replace infinispan config path').with( {
        'command' => "/bin/sed -i -e's|\\$.fcrepo.ispn.configuration:config.*infinispan.xml.|/fedora/config/infinispan.xml|' '/fedora/config/repository.json'",
        'path'    => "/bin",
      })
    }
  end
  
  # Test custom Fedora config repository.json
  context "With custom Fedora config repository.json" do
    let :params do
      {
        :fcrepo_repository_json => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.5.0/fcrepo-configs/src/main/resources/config/minimal-default/repository.json',
      }
    end
    it {
      should contain_file('/fedora/config/repository.json').with( {
        'ensure'  => 'present',
        'path'    => '/fedora/config/repository.json',
        'group'   => 'fcrepo',
        'owner'   => 'fcrepo',
        'mode'    => '0644',
      } )
    }
    it {
      should contain_staging__file('repository.json').with( {
        'target'  => '/fedora/config/repository.json',
        'source'  => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.5.0/fcrepo-configs/src/main/resources/config/minimal-default/repository.json',
      } )
    }
    it {
      should contain_exec('replace infinispan config path').with( {
        'command' => "/bin/sed -i -e's|\\$.fcrepo.ispn.configuration:config.*infinispan.xml.|/fedora/config/infinispan.xml|' '/fedora/config/repository.json'",
        'path'    => "/bin",
      })
    }
  end

  # Test default Fedora config jgroups-fcrepo-tcp.xml
  context "With default Fedora config jgroups-fcrepo-tcp.xml" do
    it {
      should contain_file('/fedora/config/jgroups-fcrepo-tcp.xml').with( {
        'ensure'  => 'present',
        'path'    => '/fedora/config/jgroups-fcrepo-tcp.xml',
        'group'   => 'fcrepo',
        'owner'   => 'fcrepo',
        'mode'    => '0644',
      } )
    }
    it {
      should contain_staging__file('jgroups-fcrepo-tcp.xml').with( {
        'target'  => '/fedora/config/jgroups-fcrepo-tcp.xml',
        'source'  => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.4.0/fcrepo-configs/src/main/resources/config/jgroups-fcrepo-tcp.xml',
      } )
    }
  end
  
  # Test custom Fedora config jgroups-fcrepo-tcp.xml
  context "With custom Fedora config jgroups-fcrepo-tcp.xml" do
    let :params do
      {
        :fcrepo_jgroups_fcrepo_tcp_xml   => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.5.0/fcrepo-configs/src/main/resources/config/jgroups-fcrepo-tcp.xml',
      }
    end
    it {
      should contain_file('/fedora/config/jgroups-fcrepo-tcp.xml').with( {
        'ensure'  => 'present',
        'path'    => '/fedora/config/jgroups-fcrepo-tcp.xml',
        'group'   => 'fcrepo',
        'owner'   => 'fcrepo',
        'mode'    => '0644',
      } )
    }
    it {
      should contain_staging__file('jgroups-fcrepo-tcp.xml').with( {
        'target'  => '/fedora/config/jgroups-fcrepo-tcp.xml',
        'source'  => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.5.0/fcrepo-configs/src/main/resources/config/jgroups-fcrepo-tcp.xml',
      } )
    }
  end
  
  # Test default Fedora config infinispan.xml
  context "With default Fedora config infinispan.xml" do
    it {
      should contain_file('/fedora/config/infinispan.xml').with( {
        'ensure'  => 'present',
        'path'    => '/fedora/config/infinispan.xml',
        'group'   => 'fcrepo',
        'owner'   => 'fcrepo',
        'mode'    => '0644',
      } )
    }
    it {
      should contain_staging__file('infinispan.xml').with( {
        'target'  => '/fedora/config/infinispan.xml',
        'source'  => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.4.0/fcrepo-configs/src/main/resources/config/infinispan/leveldb-default/infinispan.xml',
      } )
    }
  end
  
  # Test custom Fedora config infinispan.xml
  context "With custom Fedora config infinispan.xml" do
    let :params do
      {
        :fcrepo_infinispan_xml   => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.5.0/fcrepo-configs/src/main/resources/config/infinispan/leveldb-default/infinispan.xml',
      }
    end
    it {
      should contain_file('/fedora/config/infinispan.xml').with( {
        'ensure'  => 'present',
        'path'    => '/fedora/config/infinispan.xml',
        'group'   => 'fcrepo',
        'owner'   => 'fcrepo',
        'mode'    => '0644',
      } )
    }
    it{
      should contain_staging__file('infinispan.xml').with( {
        'target'  => '/fedora/config/infinispan.xml',
        'source'  => 'https://raw.githubusercontent.com/fcrepo4/fcrepo4/fcrepo-4.5.0/fcrepo-configs/src/main/resources/config/infinispan/leveldb-default/infinispan.xml',
      } )
    }
  end

  
  # Test Fedora config with MySQL database configuration
  context "With Fedora MySQL database configuration" do
    let :params do
      {
        :fcrepo_db_host      => 'somehost.example.com',
        :fcrepo_db_port      => '3307',
        :fcrepo_db_username  => 'testuser',
        :fcrepo_db_password  => 'testpass',
      }
    end
    it {
      should contain_concat__fragment('setenv-tomcat-fcrepo-catalina-opts').with( {
        'ensure'    => 'present',
        'target'    => '/fedora/tomcat7/bin/setenv.sh',
        'content'   => /somehost.example.com.+?3307.+?testuser.+?testpass/,
        }
      )
    }
  end
  
end
