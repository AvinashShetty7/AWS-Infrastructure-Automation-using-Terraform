variable "vpc_range" {
  default = "10.0.0.0/16"
}
 
variable "cidr_public1" {
  default= "10.0.0.0/24"
}

variable "cidr_public2" {
  default= "10.0.1.0/24"
}

variable "cidr_private1" {
  default= "10.0.2.0/24"
}

variable "cidr_private2" {
  default= "10.0.3.0/24"
}

variable "ami_for_jumphost" {
  default = "ami-05d2d839d4f73aafb"
}

variable "instance_type_for_jumphost" {
  default = "t3.micro"
}

variable "key_name" {
  default =  "iam_avinash"
}

variable "ami" {
  default = "ami-05d2d839d4f73aafb"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "load_balancer_type" {
  default = "application"
}