apt install -y git
git clone 'https://gitlab+deploy-token-1019111:xJcXwE1j7GYkDmy1u5QJ@gitlab.com/c21f969b5f/rea-set.git'

# install Terraform
( cd rea-set/ansible && sh ansible-install.sh )

# install Ansible
( cd rea-set/terraform && sh terraform-install.sh )
