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
silent sudo add-apt-repository ppa:chris-lea/redis-server
silent sudo add-apt-repository ppa:openjdk-r/ppa
silent sudo apt-get update -y

# Required for resque
echo 'Installing redis...'
silent sudo apt-get install redis-server -y

# cmake is required for rugged
echo 'Installing misc...'
silent sudo apt-get install cmake -y

echo 'Installing rvm and ruby...'
silent gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | silent bash -s stable --ruby
source ~/.rvm/scripts/rvm

echo 'Installing Java and Antlr'
silent sudo apt-get install openjdk-8-jdk -y

ANTLR_VERSION="antlr-4.5.3-complete.jar"
silent sudo wget -P /usr/local/lib "http://www.antlr.org/download/$ANTLR_VERSION"
echo 'export CLASSPATH=".:/usr/local/lib/*:$CLASSPATH"' >> ~/.bash_profile
echo 'alias antlr4="java -jar /usr/local/lib/antlr-*-complete.jar"' >> ~/.bash_profile

echo 'Installing eva checks...'
silent wget https://github.com/macaullyjames/eva-isvalidjavacheck/releases/download/v1.0/IsValidJavaCheck.jar
silent sudo mv *.jar /usr/local/lib/

echo 'Installing gems...'
cd /evabot/rails
silent gem install bundler
silent bundle install


echo 'Sprinkling magic...'
echo 'cd /evabot' >> ~/.bashrc

rm $logfile
