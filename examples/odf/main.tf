provider "ibm" {
  region = var.region
}

###################################################################
# Read existing resource group
###################################################################
data "ibm_resource_group" "group" {
  name = var.resource_group_name
}

###################################################################
# Create kube config path
###################################################################
resource "null_resource" "mkdir_kubeconfig_dir" {
  triggers = { always_run = timestamp() }
  provisioner "local-exec" {
    command = "mkdir -p ${var.kube_config_path}"
  }
}

###################################################################
# Read cluster config
###################################################################
data "ibm_container_cluster_config" "cluster_config" {
  depends_on        = [null_resource.mkdir_kubeconfig_dir]
  cluster_name_id   = var.cluster
  resource_group_id = data.ibm_resource_group.group.id
  config_dir        = var.kube_config_path
}

###################################################################
# Create odf instance
###################################################################
// Module:

module "odf" {
  source = "./../.."

  is_enable_odf    = var.is_enable_odf
  cluster          = var.cluster
  roks_version     = var.roks_version
  ibmcloud_api_key = var.ibmcloud_api_key // pragma: allowlist secret

  // Portworx parameters (added because git action complain)
  region         = var.region
  resource_group = var.resource_group_name
  //unique_id        = var.unique_id
  kube_config_path = data.ibm_container_cluster_config.cluster_config.config_file_path

  // ODF parameters
  monSize             = var.monSize
  monStorageClassName = var.monStorageClassName
  osdStorageClassName = var.osdStorageClassName
  osdSize             = var.osdSize
  numOfOsd            = var.numOfOsd
  billingType         = var.billingType
  ocsUpgrade          = var.ocsUpgrade
  clusterEncryption   = var.clusterEncryption
}
