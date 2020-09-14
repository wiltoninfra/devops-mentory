variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.20.0.0/16"
}

variable "subnets_cidr_pub" {
  type    = list
  default = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
}

variable "subnets_cidr_pvt" {
  type    = list
  default = ["10.20.4.0/24", "10.20.5.0/24", "10.20.6.0/24"]
}

variable "subnets_cidr_db" {
  type    = list
  default = ["10.20.7.0/24", "10.20.8.0/24", "10.20.9.0/24"]
}

variable "azs" {
  type    = list
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "all_access" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "0.0.0.0/0"
}


locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service = "Curso"
    Owner   = "Wilton"
  }
}


variable "tags" {
  default = {
    "Environment" = "DEV"
    "Version"     = "TBD"
    "Misc Tag"    = "Some Value"
  }
}


variable "ami" {
  description = "Amazon Linux AMI"
  default = "ami-4fffc834"
}

variable "instance_type" {
  description = "Instance type"
  default = "t2.micro"
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "/home/core/.ssh/id_rsa.pub"
}

variable "bootstrap_path" {
  description = "Script to install Docker Engine"
  default = "install-docker.sh"
}