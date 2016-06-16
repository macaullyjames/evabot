#!/bin/bash

logfile="/evabot/bootstrap.log"
rm -f $logfile

function silent() {
  "$@" >> $logfile 2>&1
  if [ $? -ne 0 ]; then 
    echo "Oops, something bad happened!" 1>&2
    echo "See bootstrap.log for more info." 1>&2
    exit 1
  fi
}

echo 'Updating the box...'
silent sudo apt-get update -y

echo 'Installing rvm and ruby...'
silent gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | silent bash -s stable --ruby
source ~/.rvm/scripts/rvm

echo 'Installing gems...'
cd /evabot/app
silent gem install bundler
silent bundle install

echo 'Sprinkling magic...'
echo 'cd /evabot' >> ~/.bashrc

rm $logfile
