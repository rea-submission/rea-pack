# rea-view

## Task

* https://github.com/rea-cruitment/simple-sinatra-app 

## Solution

 * (b) code building a new VM on AWS and doing a basic AWS firewall configuration;
 * (c) code configuring a new server to run a Sinatra app (AWS/VM, container or bare metal);
 * (a) code configuring an environment to run (b) and (c).

### Prerequisites

Certain AWS prerequisites are expected -- for example, one would need credentials to work with AWS API.
Also, `ssh` keys are normally used for a group of hosts rather than generated per VM. Hence, we would assume that you have the following:

 * AWS Credentials, see e.g.:
   * https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html#id_users_create_console
   * https://learn.hashicorp.com/tutorials/terraform/aws-build?in=terraform/aws-get-started#prerequisites
   * https://blog.gruntwork.io/an-introduction-to-terraform-f17df9c6d180#a9b0
 * An `ssh` keypair (`rsa 3072+` or `ed25519`), registered with AWS account above:
   * https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html

### Overview

We are going to put our Ruby code behing a gateway proxy, as shown below. 

As for the firewall configuration, some simple firewall rules will be configured at the AWS level -- "don't make your host too busy if you can delegate the job". 

This could be improved further by restricting `ssh` access to known subnet(s), [rate-limiting](http://mikhailian.mova.org/node/147) incoming connections, or installing `knockd`.

To add, we are going to use Terraform to do all the virtual hardware configuration and OS install, and Ansible to do the software configuration part.

![image1](./overview.png)

### 1. Configure Orchestration Server

This is normally a one-off (or at least infrequent) task, so we'll go with a shell script.

Deploy a new fresh container or VM with Ubuntu 20.04 LTS (22.04 LTS is likely to work as well), and run [local/build-tower.sh](local/build-tower.sh):

    apt install -y git
    git clone 'https://gitlab+deploy-token-1019111:xJcXwE1j7GYkDmy1u5QJ@gitlab.com/c21f969b5f/rea-set.git'

    # install Terraform
    ( cd rea-set/ansible && sh ansible-install.sh )

    # install Ansible
    ( cd rea-set/terraform && sh terraform-install.sh )


### 2. Create the VM

On the server configured at the previous step:

 * Get the configuration code:

```
mkdir -p /local/terraform && \
( cd /local/terraform && \
  git clone 'https://gitlab+deploy-token-1019756:cUrcUoSVi6X8iHzFRvty@gitlab.com/c21f969b5f/rea-build.git' hello )

```

 * Required: edit `/local/terraform/hello/terraform.tfvars` and set the values for `aws_access_key` & `aws_secret_key`. Edit `settings.tf` and set `keypair_name` to a name of an existing AWS keypair.

 * Optional: set a different `aws_region` in `terraform.tfvars`, edit `settings.tf` and enter a relevant `ami_id`, change `instance_type` if needed.

 * Install the AWS provider:

```
( cd /local/terraform/hello && terraform init )

```

 * Create the VM:

```
( cd /local/terraform/hello && terraform apply # -auto-approve
)
```

 * Verify: make sure that you can ssh into the new VM at `$(cat /local/terraform/hello/ip_address.txt)` with your keypair, say, with the following `~/.ssh/config`:

```
Host    *
        # put your keypair here; for agent forwarding, put the public part of the key
        IdentityFile ~/.ssh/your_key_name_here
        
        User ubuntu

        # [ https://superuser.com/questions/187779/too-many-authentication-failures-for-username/187790#187790 ]
        IdentitiesOnly yes
        
        ## ServerAliveInterval 2
        ## ServerAliveCountMax 360000

        # [ https://superuser.com/questions/325662/how-to-make-ssh-agent-automatically-add-the-key-on-demand/1114257#1114257 ]
        # AddKeysToAgent confirm
        AddKeysToAgent yes
        # Compression yes

        StrictHostKeyChecking no

        # [ http://security.stackexchange.com/questions/56268/ssh-benefits-of-using-hashed-known-hosts ]
        # [ http://superuser.com/questions/30087/remove-key-from-known-hosts ]
        # [ http://unix.stackexchange.com/questions/175071/how-to-decrypt-hostnames-of-a-crypted-ssh-known-hosts-with-a-list-of-the-hostna ]
        # [ http://unix.stackexchange.com/questions/31549/is-it-possible-to-find-out-the-hosts-in-the-known-hosts-file ]
        # [ http://serverfault.com/questions/29262/how-to-manage-my-ssh-known-hosts-file ]
        ## HashKnownHosts no

```


 * To destroy the VM, run `terraform destroy` in the same directory.


### 3. Configure the VM

On successful completion of step 2 the terraform project at `/local/terraform/hello` shall contain an Ansible inventory file, `/local/terraform/hello/ansible_hosts.ini`, which will look approximately as follows:

```
[targets]
# our target VM ip address
1.2.3.4

```

Ansible can use an inventory file at any given location, but we are going to symlink it into Ansible project folder for convenience:

 * Get the Ansible project code:

```
mkdir -p /local/ansible && \
( cd /local/ansible && \
  git clone 'https://gitlab+deploy-token-1019897:kH4QsmsWyjXEFkeskx2d@gitlab.com/c21f969b5f/rea-configure.git'  hello )

```

 * Symlink the inventory file:

```
( cd /local/ansible/hello && \
  ln -s /local/terraform/hello/ansible_hosts.ini ./ )
```

 * Test that an ssh connection to remote would work with configured ssh keys:

```
ssh $(cat /local/terraform/hello/ip_address.txt) 'ip -br a'
```

 * Deploy the app:

```
( cd /local/ansible/hello && \
  ./run-tf.sh )
```

 * Test that the installation was successful:

```
curl 'http://'$(cat /local/terraform/hello/ip_address.txt)
```

