#############################################
# Create 'Databases for Etcd' service instance
#############################################
resource "ibm_database" "etcd" {
  count                        = var.create_external_etcd ? 1 : 0
  location                     = var.region
  members_cpu_allocation_count = var.cpu_allocation_count
  members_disk_allocation_mb   = var.disk_allocation_mb
  members_memory_allocation_mb = var.memory_allocation_mb
  name                         = "${var.unique_id}-pwx-etcd"
  plan                         = var.db_plan
  resource_group_id            = data.ibm_resource_group.group.id
  service                      = "databases-for-etcd"
  service_endpoints            = var.service_endpoints
  version                      = var.db_version
  users {
    name     = var.etcd_username
    password = var.etcd_password
  }
}

# find the object in the connectionstrings list in which the `name` is var.etcd_username
locals {
  etcd_user_connectionstring = (var.create_external_etcd ?
    ibm_database.etcd[0].connectionstrings[index(ibm_database.etcd[0].connectionstrings[*].name, var.etcd_username)] :
  null)
}

resource "kubernetes_secret" "etcd" {
  count = var.create_external_etcd ? 1 : 0

  metadata {
    name      = var.etcd_secret_name
    namespace = var.kubernetes_secret_namespace
  }

  data = {
    "ca.pem" = base64decode(local.etcd_user_connectionstring.certbase64)
    username = var.etcd_username
    password = var.etcd_password
  }

}

##################################
# Install Portworx on the cluster
##################################
resource "ibm_resource_instance" "portworx" {
  depends_on = [
    kubernetes_secret.etcd,
  ]

  name = "${var.unique_id}-portworx-service"
  service           = "portworx"
  plan              = var.pwx_plan
  location          = var.region
  resource_group_id = data.ibm_resource_group.group.id

  tags = [
    "clusterid:${data.ibm_container_vpc_cluster.cluster.id}",
  ]

  parameters = {
    apikey       = var.ibmcloud_api_key
    cluster_name = var.cluster_name
    clusters     = data.ibm_container_vpc_cluster.cluster.id
    etcd_endpoint = (var.create_external_etcd ?
      "etcd:https://${local.etcd_user_connectionstring.hosts[0].hostname}:${local.etcd_user_connectionstring.hosts[0].port}"
      : null
    )
    etcd_secret      = var.create_external_etcd ? var.etcd_secret_name : null
    internal_kvdb    = var.create_external_etcd ? "external" : "internal"
    portworx_version = "Portworx: 2.9.0.1 , Stork: 2.8.2"
    secret_type      = var.secret_type

    cloud_drive               = var.cloud_drive
    storageClassName          = var.storageClassName
    num_cloud_drives          = var.num_cloud_drives
    max_storage_node_per_zone = var.max_storage_node_per_zone
    size                      = element(var.cloud_drives_sizes, 0)
    size1                     = (var.num_cloud_drives == 2) ? element(var.cloud_drives_sizes, 1) : 0
    size2                     = (var.num_cloud_drives == 3) ? element(var.cloud_drives_sizes, 2) : 0
  }

  provisioner "local-exec" {
    environment = {
      KUBECONFIG = var.kube_config_path
    }
    interpreter = ["/bin/bash", "-c"]
    command     = file("${path.module}/scripts/portworx_wait_until_ready.sh")
  }
}
