#!/bin/sh -x

# [ https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu ]
# // [ https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-with-pip ]

# [ https://docs.ansible.com/ansible/devel/reference_appendices/release_and_maintenance.html#ansible-core-changelogs ]

# // core
apt install -y python3-pip
pip3 install ansible-core==2.11

ansible-galaxy collection install community.general
ansible-galaxy collection install ansible.posix


# // optional
apt install -y sshpass

CONFFILE=$(dirname $0)'/ansible.cfg'
## export CONFFILE

# // ansible.cfg
mkdir -p /etc/ansible

( cd /etc/ansible ;
  [ -e ansible.cfg ] && cp -a ansible.cfg ansible.`date +%F-t-%s`.cfg

  ## # a working config for v.11
  ## wget 'https://raw.githubusercontent.com/ansible/ansible/99a983c92ca981f189ce97bec7b566d59300950a/examples/ansible.cfg'
)

# // use our own version of the config
cp -a "${CONFFILE}" /etc/ansible


# // ansible project directory, can be any
mkdir -p /local/ansible
# optional, reminder
( cd /local/ansible && ln -s /etc/ansible/ansible.cfg ./ )

