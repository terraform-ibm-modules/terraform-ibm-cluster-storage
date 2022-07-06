##############################################################################
# IBM Cloud Provider
##############################################################################
provider ibm {
  region = var.region
}

##############################################################################
# Data blocks
##############################################################################

data ibm_resource_group group {
  name = var.resource_group
}

data ibm_container_vpc_cluster cluster {
  name              = var.cluster
  resource_group_id = data.ibm_resource_group.group.id
}

data ibm_container_cluster_config cluster {
  cluster_name_id   = var.cluster
  resource_group_id = data.ibm_resource_group.group.id
  admin             = true
  config_dir        = path.root
}

##############################################################################
# Kubernetes Provider
##############################################################################
provider kubernetes {
  host                   = data.ibm_container_cluster_config.cluster.host
  client_certificate     = data.ibm_container_cluster_config.cluster.admin_certificate
  client_key             = data.ibm_container_cluster_config.cluster.admin_key
  cluster_ca_certificate = data.ibm_container_cluster_config.cluster.ca_certificate
}
