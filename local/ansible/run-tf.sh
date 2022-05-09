#!/bin/sh

PLAYBOOK='sinatra_hello.yml'

USERNAME='ubuntu'

# HOSTSFILE='hosts'   # uses 'targets' group
HOSTSFILE='ansible_hosts.ini'   # uses 'targets' group

# copy, link, or create a hosts file 
if [ -e /local/terraform/hello/${HOSTSFILE} ] || ln -s /local/terraform/hello/${HOSTSFILE} ./ ; then : ; else
    echo "Please symlink, copy, move or otherwise create an Ansible inventory file at '${HOSTSFILE}'; " >&2
    echo "NB: one could also use 'hosts.example.ini' as an example -- e,g, copy it to './${HOSTSFILE} and replace 127.0.0.1 for the target address" >&2
    exit 2
fi

# // debug mode
ANSIBLE_STDOUT_CALLBACK=debug ; export ANSIBLE_STDOUT_CALLBACK
ANSIBLE_HOST_KEY_CHECKING=False; export ANSIBLE_HOST_KEY_CHECKING

mkdir -p './logs'
# [ https://docs.ansible.com/ansible/latest/reference_appendices/config.html#envvar-ANSIBLE_LOG_PATH ]
ANSIBLE_LOG_PATH="logs/ansible.test."`date +%F-t-%s`'.log' ; export ANSIBLE_LOG_PATH

:<<\true
echo "about to run: <$PLAYBOOK>"
read -p "press <Enter>" DISCARDME
true

# ansible-playbook  "$PLAYBOOK"    -i "$HOSTSFILE"  -u "$USERNAME"  --become --become-user root --ask-become-pass   --ask-pass -f1 -v # --diff
ansible-playbook  "$PLAYBOOK"    -i "$HOSTSFILE"  -u "$USERNAME"  --become --become-user root -f1 -v # -v --diff

