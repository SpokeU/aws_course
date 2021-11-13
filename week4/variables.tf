variable "region" {
  default = "us-west-2"
}

variable "availability_zone_1" {
  default = "us-west-2a"
}

variable "availability_zone_2" {
  default = "us-west-2b"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "key_pair_name" {
  default = "aws_second_key_pair"
}

variable "aws_access_key" { 
}

variable "aws_secret_key" {
}

