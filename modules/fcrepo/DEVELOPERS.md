# Developer's Guide

1. [Set up the environment](#set-up-the-environment)
2. [Check the formatting](#check-the-formatting)
3. [Run the tests](#run-the-tests)
4. [Build the module](#build-the-module)
5. [Install the module](#install-the-module)
6. [Other useful commands](#other-useful-commands)

Run the following commands from the top-level module directory (where 
`Modulefile` resides), unless otherwise noted.

##Set Up the Environment

1. Install Prerequisites:  puppet, ruby, gem, and the bundler and rcov (for code coverage 
checks) gems. You will also need to install the "augeas-devel" OS package and its dependencies in
order to run the tests. On Red Hat you can install this by running 
```
    sudo yum install augeas-devel
```
2. Clone this project:
```
    git clone git://github.com/sprater/puppet-fcrepo
    cd puppet-fcrepo
```
3. Install the gems needed for development and testing (this will use the included
Gemfile to determine what needs to be installed):
```
    bundle install
```

##Check the formatting

Make sure the module conforms to the [Puppet Labs Style Guide](http://docs.puppetlabs.com/guides/style_guide.html):

    bundle exec rake lint

##Run the tests

Run the tests under the `spec/` directory:

    bundle exec rake spec

##Build the module

Build the module as a tar-gzipped package, ready for install into puppet:

    puppet module build .

##Install the module

Install the module, ignoring any upstream Puppet Forge dependencies:

    sudo puppet module install pkg/sprater-fcrepo-<version>.tar.gz --ignore-dependencies

##Other useful commands

###Clean the built module package

    bundle exec rake clean

###Clean the rspec tests

    bundle exec rake spec_clean

###Check your test coverage

    bundle exec rake coverage

