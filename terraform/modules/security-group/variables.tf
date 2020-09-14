variable "vpc_cidr" {}
variable "all_access" {}
variable "vpc_id" {}

variable "tags" {
  description = "(Required) Specifies the tags to validate."
  type        = map
  validation {
    condition     = length(var.tags) > 0
    error_message = "The `tags` value must contain at least one key/value."
  }
}

variable "http" {
  type        = number
  default     = 80
  description = "Porta Web HTTP"
}

variable "https" {
  type        = number
  default     = 443
  description = "Porta Web HTTPS"
}

variable "mysql" {
  type        = number
  default     = 3306
  description = "Porta Banco de Dados MySQL"
}

variable "ssh" {
  type        = number
  default     = 22
  description = "Remote Access SSH"
}

variable "openvpn" {
  type        = number
  default     = 1194
  description = "VPN Access"
}
