#############################################################################
# VARIABLES
#############################################################################

variable "azure_location" {
  default = "eastus"
  type    = string
}

variable "github_user_name" {
  type    = string
}

variable "github_repository" {
  default = "NeuBankv2"
  type    = string
}

variable "token" {
  type    = string
  sensitive = true
}