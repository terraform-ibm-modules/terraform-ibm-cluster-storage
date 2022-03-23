provider "ibm" {}

// Module:

module "odf" {
  source        = "./../.."
  is_enable_odf = var.is_enable_odf
  cluster       = var.cluster
}
