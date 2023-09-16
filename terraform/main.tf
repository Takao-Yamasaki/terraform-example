# ローカル変数の定義
locals {
	example_instance_type = "t3.micro"
}

# 出力値の定義
output "example_instance_id" {
	value = aws_instance.example.id
}

# EC2インスタンスの定義
resource "aws_instance" "example" {
  ami = "ami-0c3fd0f5d33134a76"
  instance_type = local.example_instance_type

  tags = {
    Name = "example"
  }
  user_data = <<EOF
	#!/bin/bash
	yum install -y httpd
	systemctl start httpd.service
EOF
}
