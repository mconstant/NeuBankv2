variable "company" {
  type = string
}

variable "region" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "db_sku_name" {
  type        = string
  description = "Enter SKU"
  default     = "GP_Gen5"
}

variable "db_license_type" {
  type        = string
  description = "Enter license type"
  default     = "BasePrice"
}

variable "db_vcores" {
  type        = number
  description = "Enter number of vCores you want to deploy"
  default     = 8
}

variable "db_storage_size_in_gb" {
  type        = number
  description = "Enter storage size in GB"
  default     = 32
}