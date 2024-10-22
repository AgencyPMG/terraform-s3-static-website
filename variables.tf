variable "app" {
  type        = string
  description = "The name of the application"
}

variable "env" {
  type        = string
  description = "The environment the application is deployed in"
}

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

variable "additional_bucket_policy_document" {
  type    = string
  default = ""
}

variable "create_iam_resources" {
  type    = bool
  default = true
}
