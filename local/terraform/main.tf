## terraform apply # -auto-approve

#
# VM settings
#

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

resource "aws_instance" "example" {
  ami                    = var.ami_id
  instance_type          = var.instance_type

  key_name               = var.keypair_name

  vpc_security_group_ids = [aws_security_group.tf_default_webserver_fw_si.id]  

  tags = {
    Name = "terraform-example-1"
  }
}


#
# firewall settings
#

# [ https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#argument-reference ]
resource "aws_security_group" "tf_default_webserver_fw_si" {
  name = "tf_default_webserver_fw"  
  
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    # description      = "all"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


#
# results
#


output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the web server"
}

# [ https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file ]
resource "local_file" "instance_ip" {
    content  = aws_instance.example.public_ip

    filename = "ip_address.txt"
    file_permission = "0644"
}

# [ https://www.terraform.io/language/functions/format ]
resource "local_file" "ansible_hosts" {
    content = format("[targets]\n# our target VM ip address\n%s\n", aws_instance.example.public_ip)

    filename = "ansible_hosts.ini"
    file_permission = "0644"
}

