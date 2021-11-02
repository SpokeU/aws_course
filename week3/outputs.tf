output "ec2_ip_addr" {
  value = aws_instance.week3EC2.public_ip
  description = "The public IP address of the main EC2 server instance."
}

output "postgresg_ip_addr" {
  value = aws_db_instance.postgresDB.address
  description = "The public IP address of the main POSTGRES server instance."
}