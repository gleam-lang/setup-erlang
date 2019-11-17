#!/bin/bash

set -eo pipefail

VERSION=$1
RELEASE=$(lsb_release -cs)
DIR=$(mktemp -d)
FILE=esl-erlang_$VERSION-1~ubuntu~$RELEASE\_amd64.deb

echo Installing required packages
sudo apt-get install -y libwxbase3.0-0v5 libwxgtk3.0-0v5 libsctp1

echo Downloading Erlang/OTP $VERSION package
wget https://packages.erlang-solutions.com/erlang/debian/pool/$FILE

echo Installing Erlang/OTP $VERSION
sudo dpkg -i $FILE

echo Cleaning up
cd
rm -r $DIR

echo Done!
