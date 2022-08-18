##############################################################################
# Account Variables
##############################################################################

variable "install_storage" {
  type        = bool
  default     = true
  description = "If set to false does not install storage and attach the volumes to the worker nodes. Enabled by default"
}

variable "ibmcloud_api_key" {
  description = "Get the ibmcloud api key from https://cloud.ibm.com/iam/apikeys"
  type        = string
}

variable "unique_id" {
  description = "Unique identifiers for all created resources"
  type        = string
}

variable "cluster" {
  description = "Name of existing roks cluster"
  type        = string
}

variable "kube_config_path" {
  description = "Path to store k8s config file: ex `~/.kube/config`"
  type        = string
}

variable "resource_group" {
  description = "Resource group of existing cluster"
  type        = string
  default     = "Default"
}

##############################################################################

##############################################################################
# Portworx Variables
##############################################################################
variable "create_external_etcd" {
  type        = bool
  default     = true
  description = "Do you want to create an external_etcd? `True` or `False`"
}

variable "region" {
  description = "The region Portworx will be installed in: us-south, us-east, eu-gb, eu-de, jp-tok, au-syd, etc."
}

# These credentials have been hard-coded because the 'Databases for etcd' service instance is not configured to have a publicly accessible endpoint by default.
# You may override these for additional security.
variable "etcd_username" {
  default = "portworxuser"
}
variable "etcd_password" {
  default = "etcdpassword123"
}
variable "etcd_secret_name" {
  default = "px-etcd-cert" # don't change this
}

##############################################################################

##############################################################################
# Database Variables
##############################################################################

variable "cpu_allocation_count" {
  description = "Enables and allocates the number of specified dedicated cores to your deployment"
  type        = number
  default     = 9
}

variable "disk_allocation_mb" {
  description = "The amount of disk space for the database, split across all members."
  type        = number
  default     = 393216
}

variable "memory_allocation_mb" {
  description = "The amount of memory in megabytes for the database, split across all members."
  type        = number
  default     = 24576
}

variable "db_plan" {
  description = "The name of the service plan that you choose for db instance. "
  type        = string
  default     = "standard"
}

variable "service_endpoints" {
  description = "Specify whether you want to enable the public, private, or both service endpoints. Supported values are public, private, or public-and-private"
  type        = string
  default     = "public"
}

variable "db_version" {
  description = "The version of the database to be provisioned. "
  type        = string
  default     = "3.3"
}

variable "kubernetes_secret_namespace" {
  description = "Name of the namespace"
  type        = string
  default     = "kube-system"
}

variable "pwx_plan" {
  description = "Portworx plan type "
  type        = string
  default     = "px-enterprise"
}

variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
  default     = "pwx"
}

variable "secret_type" {
  description = "secret type"
  type        = string
  default     = "k8s"
}

##############################################################################
# Cloud Drive Variables
##############################################################################
variable "cloud_drive" {
  description = "cloud drive support enabled"
  type        = string
  default     = "Yes"
}
variable "num_cloud_drives" {
  description = "No of drives to provisoned(max=3)"
  type        = number
  default     = 1
  validation {
    condition     = var.num_cloud_drives > 0 && var.num_cloud_drives < 4
    error_message = "Maximum number of cloud drives that can be provisioned is 3."
  }
}

variable "storage_class" {
  description = "List of the storage classes that will be used to provision cloud drives"
  type        = list(string)
  validation {
    condition     = length(var.storage_class) > 0 && length(var.storage_class) < 4
    error_message = "Maximum number of storage class that can be used is 3."
  }
}

variable "cloud_drives_sizes" {
  description = "Size of the cloud drives(Should be entered in the form [100,0,0])"
  type        = list(number)
  default     = [100, 0, 0]
  validation {
    condition     = length(var.cloud_drives_sizes) > 0 && length(var.cloud_drives_sizes) < 4
    error_message = "Maximum number of cloud drives that can be provisioned is 3."
  }
}

variable "max_storage_node_per_zone" {
  description = "number of worker nodes to be used as storage nodes"
  type        = number
  default     = 1
}

variable "px_pvc_deletion" {
  description = "pvc should be deleted after px cleanup"
  type        = bool
  default     = false
}