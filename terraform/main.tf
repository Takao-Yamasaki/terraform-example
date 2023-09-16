# プロバイダの定義(東京リージョン)
provider "aws" {
	region = "ap-northeast-1"
}

# ローカル変数の定義
locals {
	example_instance_type = "t3.micro"
}

# 現在のリージョンを取得
data "aws_region" "current" {}

# 出力値の定義
output "current_region" {
	value = data.aws_region.current.name
}
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

# EC2向けセキュリティグループの定義
resource "aws_security_group" "example_ec2" {
	name = "example-ec2"

	# 受信ルール
	# ポート80(HTTP)で全てのIPアドレスから接続を許可
	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	# 送信ルール
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

# EC2インスタンスの定義
resource "aws_instance" "example" {
  ami = data.aws_ami.recent_amazon_linux_2.image_id
  instance_type = local.example_instance_type
	# セキュリティグループを追加
	vpc_security_group_ids = [aws_security_group.example_ec2.id]

  tags = {
    Name = "example"
  }

	# Apacheのインストール
  user_data = <<EOF
	#!/bin/bash
	yum install -y httpd
	systemctl start httpd.service
EOF
}

output "example_public_dns" {
	value = aws_instance.example.public_dns
}
