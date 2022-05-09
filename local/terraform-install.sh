# [ https://learn.hashicorp.com/tutorials/terraform/install-cli ]
# [ https://www.terraform.io/downloads ]
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# // optional
#  terraform -install-autocomplete
mkdir -p /local/terraform
