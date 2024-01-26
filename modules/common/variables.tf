variable "common_tags" {
  type = map(object({
    Environment = string
    Owner       = string
    Project     = string
  }))
  default = {
    "dev" = {
      Environment = "Dev"
      Owner       = "first.last@company.com"
      Project     = "Mortgage Calculator"
    }
    "test" = {
      Environment = "Test"
      Owner       = "first.last@company.com"
      Project     = "Mortgage Calculator"
    }
    "prod" = {
      Environment = "Prod"
      Owner       = "first.last@company.com"
      Project     = "Mortgage Calculator"
    }
  }
}
