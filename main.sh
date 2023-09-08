#!/bin/bash

set -eo pipefail

OTP_VERSION="$1"
REBAR3_VERSION="$2"
RELEASE=$(lsb_release -cs)
DIR=$(mktemp -d)
pushd "$DIR"
FILE="esl-erlang_${OTP_VERSION}-1~ubuntu~${RELEASE}_amd64.deb"

echo Installing required packages
sudo apt-get install -y libwxbase3.0-0v5 libwxgtk3.0-gtk3-0v5 libsctp1

echo Downloading Erlang/OTP "$OTP_VERSION" package
wget -q https://packages.erlang-solutions.com/erlang/debian/pool/"$FILE"

echo Installing Erlang/OTP "$OTP_VERSION"
sudo dpkg -i "$FILE"

if [ "$REBAR3_VERSION" == "true" ]
then
    case "$OTP_VERSION" in
        "26"*) REBAR3_VERSION="3.22.1" ;;
        "25"*) REBAR3_VERSION="3.22.1" ;;
        "24"*) REBAR3_VERSION="3.16.1" ;;
        "23"*) REBAR3_VERSION="3.16.1" ;;
        "22"*) REBAR3_VERSION="3.16.1" ;;
        "21"*) REBAR3_VERSION="3.15.2" ;;
        "20"*) REBAR3_VERSION="3.15.2" ;;
        "19"*) REBAR3_VERSION="3.15.2" ;;
        "18"*) REBAR3_VERSION="3.11.1" ;;
        "17"*) REBAR3_VERSION="3.10.0" ;;
        *)
            echo Installing Rebar3 for OTP version "$OTP_VERSION" not supported
            REBAR3_VERSION=""
            ;;
    esac
fi

if [ -n "$REBAR3_VERSION" ]
then
    echo Downloading Rebar3 "$REBAR3_VERSION"
    wget https://github.com/erlang/rebar3/releases/download/"$REBAR3_VERSION"/rebar3
    chmod +x rebar3
    mkdir -p "$HOME"/bin
    mv rebar3 "$HOME"/bin/
    echo "$HOME/bin" >> "$GITHUB_PATH"
fi

echo Cleaning up
popd
rm -r "$DIR"

echo Done!
