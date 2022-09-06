##################################
# Upgrade Portworx on the cluster
##################################

provider "helm" {
  kubernetes {
    config_path = var.kube_config_path
  }
}

resource "helm_release" "px" {
  repository        = "https://raw.githubusercontent.com/IBM/charts/master/repo/community"
  chart             = "portworx"
  name              = "portworx"
  reuse_values      = true
  dependency_update = true
  force_update      = true
  recreate_pods     = false
  wait              = true
  max_history       = 1
}