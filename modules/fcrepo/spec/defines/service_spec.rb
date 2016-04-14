# spec/classes/service_spec.pp

require 'spec_helper'

describe 'fcrepo::service', :type => :define do
  let :pre_condition do
    'class { "fcrepo": }'
  end
  
  let :facts do
    {
      :osfamily => 'RedHat',
      :augeasversion => '1.0.0',
    } 
  end
  let :title do
    'default'
  end

   # Test Fedora 4 startup service
  context "With Fedora 4 startup service - enabled" do
      let :params do
      {
         :service_enable      => true,
         :service_ensure      => 'running',
      }
    end
    it {
      should contain_tomcat__service('tomcat-fcrepo').with( {
        'catalina_base'      => '/fedora/tomcat7',
        'service_name'       => 'tomcat-fcrepo',
        'service_enable'     => true,
        'service_ensure'     => 'running',
      } )
    }
  end

   # Test Fedora 4 startup service -- disabled
  context "With Fedora 4 startup service - disabled" do
      let :params do
      {
         :service_enable      => false,
         :service_ensure      => 'stopped',
      }
    end
    it {
      should contain_tomcat__service('tomcat-fcrepo').with( {
        'catalina_base'      => '/fedora/tomcat7',
        'service_name'       => 'tomcat-fcrepo',
        'service_enable'     => false,
        'service_ensure'     => 'stopped',
      } )
    }
  end
  
end