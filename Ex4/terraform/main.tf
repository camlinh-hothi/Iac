resource "aws_instance" "nginx_instance" {
  ami                    = "ami-019864083c8ef7aa5"  # Amazon Linux 2
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  key_name               = "myKey"

  tags = {
    Name = "nginx-server"
  }
}

resource "aws_instance" "php_instance" {
  ami                    = "ami-019864083c8ef7aa5"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.php_sg.id]
  key_name               = "myKey"

  tags = {
    Name = "php-server"
  }
}

resource "aws_instance" "db_instance" {
  ami                    = "ami-019864083c8ef7aa5"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  key_name               = "myKey"

  tags = {
    Name = "db-server"
  }
}
# VPC principal
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Sous-réseau public
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Groupe de sécurité pour NGINX
resource "aws_security_group" "nginx_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Groupe de sécurité pour PHP-FPM
resource "aws_security_group" "php_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port       = 9000
    to_port         = 9000
    protocol        = "tcp"
    security_groups = [aws_security_group.nginx_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Groupe de sécurité pour MariaDB
resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.php_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
