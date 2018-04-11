variable "AZ" {
  default = "ap-southeast-1a"
}

variable "vpc_id" {}
variable "igw" {}
variable "public-cidr" {}

# Tagging vars
variable "tag_prefix" {
  default = ""
}

variable "common_tags" {
  type = "map"

  default = {
    role = ""
    env  = ""
  }
}

variable "key_name" {}
variable "ami_id" {}
