#####################################################
# Portworx Module Example
# Copyright 2020 IBM
#####################################################
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
# Create portworx_with_cloud_drive instance
###################################################################
module "portworx" {
  source = "../../modules/portworx_with_cloud_drive"

  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
  resource_group   = var.resource_group_name
  cluster          = var.cluster
  unique_id        = var.unique_id
  kube_config_path = data.ibm_container_cluster_config.cluster_config.config_file_path

  // Adding cloud drives parameters
  max_storage_node_per_zone = var.max_storage_node_per_zone
  num_cloud_drives          = var.num_cloud_drives
  cloud_drives_sizes        = var.cloud_drives_sizes
  storage_class             = var.storage_class
  // These credentials have been hard-coded because the 'Databases for etcd' service instance is not configured to have a publicly accessible endpoint by default.
  // You may override these for additional security.
  create_external_etcd        = var.create_external_etcd
  etcd_username               = var.etcd_username
  etcd_password               = var.etcd_password
  etcd_secret_name            = var.etcd_secret_name
  cpu_allocation_count        = var.cpu_allocation_count
  disk_allocation_mb          = var.disk_allocation_mb
  memory_allocation_mb        = var.memory_allocation_mb
  db_plan                     = var.db_plan
  service_endpoints           = var.service_endpoints
  db_version                  = var.db_version
  kubernetes_secret_namespace = var.kubernetes_secret_namespace
  pwx_plan                    = var.pwx_plan
  cluster_name                = var.cluster_name
  secret_type                 = var.secret_type
}
###################################################################
# Uninstall portworx instance
###################################################################
resource "null_resource" "portworx_destroy" {
  triggers = {
    cluster    = var.cluster_name
    PVC_DELETE = var.px_pvc_deletion
  }
  provisioner "local-exec" {
    when       = destroy
    command    = "/bin/bash ../../modules/portworx_with_cloud_drive/scripts/portworx_destroy.sh"
    on_failure = fail
    environment = {
      cluster    = self.triggers.cluster
      PVC_DELETE = self.triggers.PVC_DELETE
    }
  }
}