#! /bin/bash
if [ ! -f "/var/setup-script-run" ] ; then
#sudo apt-get update
#sudo apt-get install -qy wget git
sudo apt-get install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -qy ansible

sudo wget -qO- https://get.docker.com/ | sh

wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py

touch /var/setup-script-run
fi

SITE_PREFIX=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/site" -H "Metadata-Flavor: Google")
#export SITE_PREFIX 

sudo mkdir -p /etc/ansible/facts.d/
sudo rm -f /etc/ansible/facts.d/site.fact
#touch ~/site.fact
printf "[info]\nprefix=$SITE_PREFIX\n" > site.fact
sudo mv ~/site.fact /etc/ansible/facts.d/site.fact

sudo rm -f web-server.yml

wget https://raw.githubusercontent.com/idguk/playbooks/master/web-server.yml

sudo ansible-playbook web-server.yml -i 'localhost,' --connection=local
