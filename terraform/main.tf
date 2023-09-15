# デフォルト値の定義
variable "example_instance_type" {
	default = "t3.micro"
}

# EC2インスタンスの定義
resource "aws_instance" "example" {
  ami = "ami-0c3fd0f5d33134a76"
  instance_type = var.example_instance_type

  tags = {
    Name = "example"
  }
  user_data = <<EOF
	#!/bin/bash
	yum install -y httpd
	systemctl start httpd.service
EOF
}
