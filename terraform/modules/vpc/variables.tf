variable "region" {}
variable "vpc_cidr" {}
variable "all_access" {}
variable "subnets_cidr_pub" {}
variable "subnets_cidr_pvt" {}
variable "subnets_cidr_db" {}
variable "azs" {}

variable "tags" {
  description = "(Required) Specifies the tags to validate."
  type        = map
  validation {
    condition     = length(var.tags) > 0
    error_message = "The `tags` value must contain at least one key/value."
  }
}

