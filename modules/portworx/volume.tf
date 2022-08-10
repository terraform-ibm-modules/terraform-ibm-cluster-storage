##############################################################################
# Read each worker information attached to cluster
##############################################################################
data "ibm_container_vpc_cluster_worker" "worker" {
  count = length(data.ibm_container_vpc_cluster.cluster.workers)

  worker_id         = element(data.ibm_container_vpc_cluster.cluster.workers, count.index)
  cluster_name_id   = data.ibm_container_vpc_cluster.cluster.id
  resource_group_id = data.ibm_resource_group.group.id
}

###############################################################################
# Read subnet attached to each worker
###############################################################################
data "ibm_is_subnet" "subnet" {
  count = length(data.ibm_container_vpc_cluster_worker.worker)

  identifier = data.ibm_container_vpc_cluster_worker.worker[count.index].network_interfaces[0].subnet_id
}

###############################################################################
# Create volume for each worker node
###############################################################################
#
resource "ibm_is_volume" "volume" {

  depends_on = [
    data.ibm_is_subnet.subnet
  ]

  count = var.install_storage ? length(data.ibm_container_vpc_cluster.cluster.workers) : 0

  name           = "vol-workerss-${element(split("-", data.ibm_container_vpc_cluster.cluster.workers[count.index]), 4)}"
  profile        = var.profile
  zone           = data.ibm_is_subnet.subnet[count.index].zone
  resource_group = data.ibm_resource_group.group.id
  capacity       = var.capacity
}

###############################################################################
# Attach volume to each worker node
###############################################################################
resource "ibm_container_storage_attachment" "volume_attach" {
  count   = var.install_storage ? length(data.ibm_container_vpc_cluster_worker.worker) : 0
  volume  = ibm_is_volume.volume[count.index].id
  cluster = data.ibm_container_vpc_cluster.cluster.id
  worker  = data.ibm_container_vpc_cluster_worker.worker[count.index].id
}

