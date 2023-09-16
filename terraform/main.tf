# ローカル変数の定義
locals {
	example_instance_type = "t3.micro"
}

# 出力値の定義
output "example_instance_id" {
	value = aws_instance.example.id
}

# データソースの定義
# 最新のAmazon Linux2のAMIを参照
data "aws_ami" "recent_amazon_linux_2" {
	# 最新のAMIを取得
	most_recent = true
	owners = ["amazon"]

	# 検索条件を指定
	filter {
		name = "name"
		values = ["amzn2-ami-amd-hvm-2.0.20230906.0-x86_64-gp2"]
	}

	filter {
		name = "state"
		values = ["available"]
	}
}

# EC2インスタンスの定義
resource "aws_instance" "example" {
  ami = data.aws_ami.recent_amazon_linux_2.image_id
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
