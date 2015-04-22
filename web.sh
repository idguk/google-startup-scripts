#! /bin/bash
#script run as root
if [ ! -f "/var/setup-script-run" ] ; then
#apt-get update
#apt-get install -qy wget git
apt-get install software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get install -qy ansible

sudo wget -qO- https://get.docker.com/ | sh

wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py

touch /var/setup-script-run
fi

sudo -H pip install --upgrade pip

SITE_PREFIX=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/site" -H "Metadata-Flavor: Google")
#export SITE_PREFIX 

rm -f ~/vault-pass.txt
curl "http://metadata.google.internal/computeMetadata/v1/project/attributes/vault-pass" -H "Metadata-Flavor: Google" > /root/vault-pass.txt

mkdir -p /etc/ansible/playbooks/
mkdir -p /etc/ansible/facts.d/
rm -f /etc/ansible/facts.d/site.fact
#touch ~/site.fact
printf "[info]\nprefix=$SITE_PREFIX\n" > /tmp/site.fact
mv /tmp/site.fact /etc/ansible/facts.d/site.fact

cd /etc/ansible/playbooks
rm -f *.yml
wget https://raw.githubusercontent.com/idguk/playbooks/master/web-server.yml
wget https://raw.githubusercontent.com/idguk/playbooks/master/ssh-vars.yml

ansible-playbook web-server.yml -i 'localhost,' --connection=local --vault-password-file=/root/vault-pass.txt
