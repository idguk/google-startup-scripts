#! /bin/bash
if [ ! -f "/var/setup-script-run" ] ; then
sudo apt-get update
sudo apt-get -q wget git
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -qy ansible

sudo wget -qO- https://get.docker.com/ | sh

wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py

touch /var/setup-script-run
fi