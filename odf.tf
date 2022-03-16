##################################
# Install ODF on the cluster
##################################

# Install ODF if the rocks version is v4.7 or newer
resource "null_resource" "enable_odf" {
  count = var.is_enable_odf ? 1 : 0

  triggers = {
    IC_API_KEY = var.ibmcloud_api_key
    CLUSTER = var.cluster
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "${path.module}/scripts/install_odf.sh"

    environment = {
      IC_API_KEY = var.ibmcloud_api_key
      CLUSTER    = var.cluster
      MON_STORAGE_CLASS_NAME = var.monStorageClassName
      OSD_SIZE = var.osdSize
      WORKER_NODES = var.workerNodes
      OCS_UPGRADE = var.ocsUpgrade
      MON_SIZE = var.monSize
      NUM_OF_OSD = var.numOfOsd
      OSD_STORAGE_CLASS_NAME = var.osdStorageClassName
      CLUSTER_ENCRYPTION = var.clusterEncryption
    }
  }

  provisioner "local-exec" {
    when        = destroy

    interpreter = ["/bin/bash", "-c"]
    command = "${path.module}/scripts/uninstall_odf.sh"

    environment = {
      IC_API_KEY = self.triggers.IC_API_KEY
      CLUSTER = self.triggers.CLUSTER
    }
  }
}