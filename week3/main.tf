resource "aws_instance" "week3EC2" {
  ami = "ami-0c2d06d50ce30b442"
  instance_type = "t2.micro"
  key_name = var.key_pair_name
  security_groups = [ aws_security_group.allow_web.name ]
  user_data = filebase64("${path.module}/files/ec2-startup.sh")
  iam_instance_profile = aws_iam_instance_profile.s3_profile.name
}

resource "aws_db_instance" "postgresDB" {
  engine = "postgres"
  engine_version = "12.8"
  identifier = "week3postgres"
  instance_class = "db.t2.micro"
  name = "MY_POSTGRES"
  username = var.RDS_username
  password = var.RDS_password
  allocated_storage = 20
  vpc_security_group_ids = ["${aws_security_group.rds.id}"]
}