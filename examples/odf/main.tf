provider "ibm" {
  region = var.region
}

// Module:

module "odf" {
  source = "./../.."
  // TODO: With Terraform 0.13 replace the parameter 'enable' or the conditional expression using 'with_iaf' with 'count'
  is_enable_odf = var.is_enable_odf
  cluster       = var.cluster
}
