module "final_work_vpc" {
	source = "../aws-vpc"
}

module "sg" {
	source      = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git?ref=v5.1.1"

	name        = "final_work_security_group"
	description = "Security Group do Trabalho"
	vpc_id      = module.final_work_vpc.vpc_id

	ingress_with_cidr_blocks = [
		{
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		description = "SSH"
		cidr_blocks = "0.0.0.0/0"
		},
		{
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		description = "open http port"
		cidr_blocks = "0.0.0.0/0" 
		},
		{
		from_port   = 3000
		to_port     = 3000
		protocol    = "tcp"
		description = "open http port"
		cidr_blocks = "0.0.0.0/0" 
		},

	]
	egress_with_cidr_blocks = [
		{
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		description = "All traffic"
		cidr_blocks = "0.0.0.0/0"
		}
	]

	tags = {
		Terraform   = "true"
		Environment = "dev"
	}
}

data "aws_ami" "ubuntu_server" {
	most_recent = true
	owners      = ["099720109477"]

	filter {
		name   = "name"
		values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
	}
	filter {
		name   = "virtualization-type"
		values = ["hvm"]
	}
}

module "ec2_instance" {
	source                 = "git::https://github.com/terraform-aws-modules/terraform-aws-ec2-instance.git?ref=v5.6.0"
	depends_on             = [module.sg]
	ami                    = data.aws_ami.ubuntu_server.id
	instance_type          = var.instance_type
	count                  = 1
	key_name               = var.key_name
	monitoring             = true
	associate_public_ip_address = true
	vpc_security_group_ids = [module.sg.security_group_id]
	subnet_id              = module.final_work_vpc.subnet_ids[0]
	root_block_device = [
		{
		volume_type = "gp3"
		volume_size = 10
		}
	]
	user_data = <<-EOF
				#!/bin/bash
				curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

				# Carregar o NVM e instalar a última versão do Node.js
				export NVM_DIR="$HOME/.nvm"
				[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Carregar o NVM
				[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Carregar a conclusão do Bash

				nvm install node  # Instalar a última versão do Node.js

				# Instalar o Nest CLI (Command Line Interface) globalmente
				npm install -g @nestjs/cli

				# Criar um novo projeto Nest.js
				nest new my-nest-project
				EOF

	tags = {
		Terraform   = "true"
		Environment = "dev"
		Project     = "Trabalho-final"
		Name        = "Trabalho-final-instance-${count.index}"
	}
}


module "alb" {
	source  = "git::https://github.com/terraform-aws-modules/terraform-aws-alb.git?ref=v6.0.0"
	name    = "my-alb"
	load_balancer_type = "application"
	vpc_id             = module.final_work_vpc.vpc_id
	subnets            = module.final_work_vpc.subnet_ids
	security_groups    = [module.sg.security_group_id]

	http_tcp_listeners = [{
		port               = 80
		protocol           = "HTTP"
		target_group_index = 0
	}]

	target_groups = [{
		name_prefix      = "tg"
		backend_protocol = "HTTP"
		backend_port     = 3000
		target_type      = "instance"
	}]

	tags = {
		Terraform   = "true"
		Environment = "dev"
		Project     = "Trabalho-final"
	}
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
	count = length(module.ec2_instance)

	target_group_arn = module.alb.target_group_arns[0]
	target_id        = module.ec2_instance[count.index].id
	port             = 80
}
