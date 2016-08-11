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

ANTLRPATH="/usr/local/lib/antlr-4.5.3-complete.jar"
silent sudo curl -o $ANTLRPATH \
  http://www.antlr.org/download/antlr-4.5.3-complete.jar
echo "ANTLRPATH='$ANTLRPATH'" >> ~/.bash_profile
echo 'export CLASSPATH=".:$ANTLRPATH:$CLASSPATH"' >> ~/.bash_profile
echo 'alias antlr4="java -jar $ANTLRPATH"' >> ~/.bash_profile
gem install antlr4

echo 'Installing gems...'
cd /evabot/rails
silent gem install bundler
silent bundle install


echo 'Sprinkling magic...'
echo 'cd /evabot' >> ~/.bashrc

rm $logfile
