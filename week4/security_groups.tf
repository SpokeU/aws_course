resource "aws_security_group" "private_sg" {
  name = "private"
  vpc_id = aws_vpc.week4-vpc.id
  description = "SSH and ping only"

  # Only postgres in
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private SG"
  }
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  
  vpc_id = aws_vpc.week4-vpc.id
  description = "Allow WEB inbound traffic"

  ingress {
      description      = "All"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  ingress {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  egress {
      description = "all allowed"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  tags = {
    Name = "Allow_WEB"
  }
}

resource "aws_security_group" "nat_sg" {
  name        = "allow_all_tcp_traffic"
  
  vpc_id = aws_vpc.week4-vpc.id
  description = "Allow all tcp local traffic"

  ingress {
      description      = "all tcp"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      self = true
    }

  egress {
      description = "all allowed"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  tags = {
    Name = "Public SG"
  }
}