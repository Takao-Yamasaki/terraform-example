# HTTPサーバーモジュールの定義
# 入力パラメータ: EC2のインスタンスタイプ
variable "instance_type" {}

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
resource "aws_instance" "default" {
  ami = data.aws_ami.recent_amazon_linux_2.image_id
  instance_type = var.instance_type
	# セキュリティグループを追加
	vpc_security_group_ids = [aws_security_group.default.id]

	# Apacheのインストールスクリプトをファイル読み込み
  user_data = file("./user_data.sh")
}

# EC2向けセキュリティグループの定義
resource "aws_security_group" "default" {
	name = "ec2"

	# インバウンドルール
	# ポート80(HTTP)で全てのIPアドレスから接続を許可
	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	# アウトバウンドルール
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

# 出力パラメータ: EC2のパブリックDNS
output "public_dns" {
	value = aws_instance.default.public_dns
}
