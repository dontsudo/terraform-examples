# 👉 EC2 용 SSH 키 페어 정의
resource "aws_key_pair" "web_admin" {
  key_name = "web_admin"
  public_key = file("~/.ssh/web_admin.pub")
}

# 👉 SSH 접속 허용을 위한 시큐리티 그룹
resource "aws_security_group" "ssh" {
  name = "allow_ssh_from_all"
  description = "Allow SSH Port From All"
  ingress { # 인바운드 트래픽을 정의하는 속성
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 👉 EC2 인스턴스 정의
# 기본 Security Group 불러오기 - data로 불러오기
data "aws_security_group" "default" {
  name = "default"
  id = "sg-0060fbfb8a401dc14"
}

resource "aws_instance" "web" {
  ami = "ami-0a93a08544874b3b7" # amzn2-ami-hvm-2.0.20200207.1-x86_64-gp2
  instance_type = "t3.micro"
  key_name = aws_key_pair.web_admin.key_name
  vpc_security_group_ids = [
    aws_security_group.ssh.id,  # SSH 허용 시큐리티 그룹
    data.aws_security_group.default.id  # Default VPC 시큐리티 그룹
  ]
}


