resource "aws_vpc" "week4-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "week4_VPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.week4-vpc.id

  tags = {
    Name = "Main"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.week4-vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
    }
  

  tags = {
    "Name" = "public-route-table"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.week4-vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      instance_id = aws_instance.ec2_nat.id
    }

  tags = {
    "Name" = "private-route-table"
  }
}

resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "private_route_association" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_subnet" "public-subnet" {
    vpc_id = aws_vpc.week4-vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = var.availability_zone_1

    tags = {
      "Name" = "public-subnet"
    }
}

resource "aws_subnet" "private-subnet" {
  vpc_id = aws_vpc.week4-vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = var.availability_zone_2

    tags = {
      "Name" = "private-subnet"
    }
}

resource "aws_instance" "ec2_public" {
  ami = "ami-0c2d06d50ce30b442"
  instance_type = "t2.micro"
  key_name = var.key_pair_name
  vpc_security_group_ids = [ aws_security_group.allow_web.id ]
  user_data = templatefile("${path.module}/files/ec2-startup.sh", {server = "public"})
  subnet_id = aws_subnet.public-subnet.id

  tags = {
      "Name" = "public instatce"
    }
}

resource "aws_instance" "ec2_private" {
  ami = "ami-0c2d06d50ce30b442"
  instance_type = "t2.micro"
  key_name = var.key_pair_name
  vpc_security_group_ids = [ aws_security_group.allow_web.id ]
  user_data = templatefile("${path.module}/files/ec2-startup.sh", {server = "private"})
  subnet_id = aws_subnet.private-subnet.id

  tags = {
      "Name" = "private instatce"
    }
}

resource "aws_instance" "ec2_nat" {
  ami = "ami-0032ea5ae08aa27a2"
  instance_type = "t2.micro"
  key_name = var.key_pair_name
  vpc_security_group_ids = [ aws_security_group.allow_web.id ]
  #user_data = filebase64("${path.module}/files/ec2-startup.sh")
  #iam_instance_profile = aws_iam_instance_profile.s3_profile.name
  subnet_id = aws_subnet.public-subnet.id
  source_dest_check = false

  tags = {
      "Name" = "public nat instance"
    }
}

##Load Balancer

resource "aws_lb_target_group" "my-tg" {
  name = "week4-tg-tf"

  protocol = "HTTP"
  port = 80

  vpc_id = aws_vpc.week4-vpc.id

  health_check {
    enabled = true
    protocol = "HTTP"
    path = "/index.html"
  }
}

resource "aws_lb_target_group_attachment" "public_tg_attachment" {
  target_group_arn = aws_lb_target_group.my-tg.arn
  target_id        = aws_instance.ec2_public.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "private_tg_attachment" {
  target_group_arn = aws_lb_target_group.my-tg.arn
  target_id        = aws_instance.ec2_private.id
  port             = 80
}

resource "aws_lb" "my_lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_web.id]
  subnets = [ aws_subnet.public-subnet.id, aws_subnet.private-subnet.id ]

  tags = {
    Name = "week4-load-balancer"
  }
}

resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-tg.arn
  }
}