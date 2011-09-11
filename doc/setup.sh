#!/bin/bash

#Setup script for quickly getting up to speed with Gamer-Ryoudan 
#functionality. Run this by using "bash setup.sh", but not before
#making it executable.
#
#Notes on installation follow at the bottom.

print_status() {
  echo "============================================"
  echo "Installing $1"
  echo "============================================"
}

#Libraries

print_status curl
sudo apt-get install curl

print_status MySQL-Admin
sudo apt-get install mysql-admin

print_status libmysqlclient16-dev
sudo apt-get install libmysqlclient16-dev

print_status libmysql-ruby
sudo apt-get install libmysql-ruby

print_status libreadline6-dev
sudo apt-get install libreadline6-dev

print_status libmagickwand-dev
sudo apt-get install libmagickwand-dev

print_status libssl-dev
sudo apt-get install libssl-dev

print_status RVM
bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)

#load rvm into session
[[ -s "/home/marseille/.rvm/scripts/rvm" ]] && source "/home/marseille/.rvm/scripts/rvm"

#ruby setup

print_status ruby-1.8.7
rvm install ruby-1.8.7

#configure ruby (helps prevent installation problems later on)
echo "configuring ruby"
rvm ruby-1.8.7
cd ~/.rvm/src/ruby-1.8.7-p352/ext/openssl;rvm 1.8.7 extconf.rb;make;make install

#Gem setup
print_status rails-2.3.8
rvm 1.8.7 gem install rails -v 2.3.8

print_status mysql-2.8.1-gem
rvm 1.8.7  gem install mysql -v 2.8.1

print_status authlogic-2.1.6
rvm 1.8.7  gem install authlogic -v 2.1.6

print_status rmagick-2.13.1
rvm 1.8.7  gem install rmagick -v 2.13.1

print_status ruby-github-0.0.3
rvm 1.8.7  gem install ruby-github -v 0.0.3

print_status aws-s3-0.6.2
rvm 1.8.7  gem install aws-s3 -v 0.6.2

print_status will_paginate-2.3.16
rvm 1.8.7  gem install will_paginate -v 2.3.16

#*RVM - don't forget to add [[ -s "/home/mars/.rvm/scripts/rvm" ]] && source "/#home/mars/.rvm/scripts/rvm" to your .bashrc if you want rvm loaded into every #shell you bring up
#     - You may have to (or want to) add "rvm ruby-1.8.7" to your .bashrc too.

#*That "cd ~/.rvm" command was made for ruby-1.8.7-p352, your version installed #from rvm may be different or you may want it to be different. If it is, change #the command accordingly

#**Lots of No definition for XYZ will show up during mysql and rmagick gem #installs, this is normal.
