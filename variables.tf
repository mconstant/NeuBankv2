variable "region" {
  type = string
}

variable "company" {
  type    = string
  default = "neubank"
}

variable "enable" {
  description = "Turn env on?"
  type        = bool
  default     = false
}