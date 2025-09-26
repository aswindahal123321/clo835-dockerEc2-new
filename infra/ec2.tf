locals {
  user_data = <<-EOF
  #!/bin/bash
  set -eux
  yum update -y
  amazon-linux-extras install docker -y || yum install -y docker
  systemctl enable docker && systemctl start docker
  usermod -aG docker ec2-user || true
  EOF
}

resource "aws_instance" "app" {
  ami                         = data.aws_ami.al2.id
  instance_type               = var.instance_type
  key_name      = aws_key_pair.finalkey.key_name
  subnet_id                   = tolist(data.aws_subnets.default_public.ids)[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  user_data                   = local.user_data

  tags = {
    Name = "clo835-ec2"
  }
}

data "aws_ami" "al2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


resource "aws_key_pair" "finalkey" {
  key_name   = "finalkey"
  public_key = file("/home/ec2-user/environment/finalkey.pem.pub")
}