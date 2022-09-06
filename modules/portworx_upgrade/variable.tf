##############################################################################
# Portworx Upgrade Variables
##############################################################################

variable "kube_config_path" {
  description = "Path to store k8s config file: ex `~/.kube/config`"
  type        = string
  default     = "~/.kube/config"
}

