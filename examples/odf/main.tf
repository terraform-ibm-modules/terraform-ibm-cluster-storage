provider "ibm" {}

// Module:

module "odf" {
  source        = "./../.."

  is_enable_odf = var.is_enable_odf
  cluster       = var.cluster
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
  resource_group   = var.resource_group_name
  unique_id        = var.unique_id
  kube_config_path = data.ibm_container_cluster_config.cluster_config.config_file_path
}
