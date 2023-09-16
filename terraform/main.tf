# プロバイダの定義(東京リージョン)
provider "aws" {
	region = "ap-northeast-1"
}

# HTTPサーバーモジュールの利用
module "web_server" {
	source = "./http_server"
	instance_type = "t3.micro"
}

# EC2のパブリックDNSの出力
output "public_dns" {
	value = module.web_server.public_dns
}
