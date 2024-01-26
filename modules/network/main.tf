module "vnet" {
  source = "./vnet"

  company = var.company
  region  = var.region
  rg_name = var.rg_name
}