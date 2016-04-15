# fcrepo4-vagrant

###Description
This allows you to start up Fedora 4 in a vagrant VM for testing.

###How to use

1. Clone this project
  ```
  git clone git@github.com:nulib/fcrepo4-vagrant.git
  cd fcrepo4-vagrant
  ```

2. Configure the Vagrantfile to your liking. Specifically, set the storagetype to
either "mysql", "postgresql", or "leveldb". You may also wish to change the forwarding
ports.

3. Make sure you have Vagrant and VirtualBox installed.

4. Use the command:
  ```
  vagrant up
  ```
  And it will install and the machine will start up.
  
5. You can use the VM by typing:
  ```
  vagrant ssh
  ```
  Or by accessing http://localhost:9080/fcrepo/rest on your web browser. While Fedora 4 
  is configured to use port 8080 on the guest machine, the Vagrantfile by default is set
  to forward port 9080 on your host to port 8080.
  
###Other notes
If you want to make changes, edit manifests/init.pp for the specific configuration. 
Much of Fedora 4's config comes from the Puppet module here:
https://github.com/sprater/puppet-fcrepo 

Also, the way it is configured, if you want to make a change to manifests/init.pp, you can
use "vagrant provision" to apply your new configuration. However, the Fedora 4 configuration
files may not change. You'll either need to delete the configuration files and then run 
"vagrant provision", or install everything fresh by running "vagrant destroy" and then 
"vagrant up" (recommended).