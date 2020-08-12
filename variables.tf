variable "name" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "cert_arn" {
  type = string
}

variable "additional_policies" {
  type    = list(string)
  default = []
}
