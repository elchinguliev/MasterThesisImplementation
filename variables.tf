variable "location" {}
variable "admin_username" {}
variable "ssh_public_key" {}
variable "project_name" {
  type    = string
  default = "enterprise"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "owner" {
  type    = string
  default = "elchin"
}

variable "cost_center" {
  type    = string
  default = "thesis"
}

# Public DNS name you own (example: test.org)
# If you don't own a domain, keep CDN but skip Azure DNS zone creation.
variable "domain_name" {
  type    = string
  default = "test.org"
}

# CDN subdomain (www)
variable "cdn_subdomain" {
  type    = string
  default = "www"
}
