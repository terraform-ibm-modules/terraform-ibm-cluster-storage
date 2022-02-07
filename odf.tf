##################################
# Install ODF on the cluster
##################################

# Install ODF if the rocks version is v4.7 or newer
resource "null_resource" "odf" {
  count = var.is_enable_odf && var.roks_version != "4.6" ? 1 : 0

  provisioner "local-exec" {
    environment = {
      KUBECONFIG = var.kube_config_path
    }

    interpreter = ["/bin/bash", "-c"]
    command = "ibmcloud kubectl cluster addon enable openshift-data-foundation -c ${var.cluster} --version 4.7.0 --param \"odfDeploy=true\""
  }
}