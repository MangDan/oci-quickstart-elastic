variable "tenancy_ocid" {}
#variable "user_ocid" {}
#variable "fingerprint" {}
#variable "private_key_path" {}
variable "region" {}

variable "compartment_ocid" {}
variable "ssh_public_key" {
  default = "id_rsa.pub"
}

# Defines the number of instances to deploy
variable "num_nodes" {
  default = "1"
}

# Choose an Availability Domain
variable "availability_domain" {
  default = "1"
}
