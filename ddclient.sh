#!/bin/sh
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install ddclient
sudo cp ddclient.conf /etc/
sudo cp etc-default-ddclient /etc/default/ddclient
sudo service ddclient restart
sudo service ddclient status
sudo ddclient -verbose -debug -noquiet -query
