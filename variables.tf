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
  description = "Path to the k8s config file: ex `~/.kube/config`"
  type        = string
}

variable "resource_group" {
  description = "Resource group of existing cluster"
  type        = string
}

##############################################################################

##############################################################################
# Block Storage Variables
##############################################################################

variable "capacity" {
  description = "Capacity for all block storage volumes provisioned in gigabytes"
  type        = number
  default     = 100
}

variable "profile" {
  description = "The profile to use for this volume."
  type        = string
  default     = "10iops-tier"
}

##############################################################################

##############################################################################
# Portworx Variables
##############################################################################
variable "create_external_etcd" {
  type        = bool
  default     = false
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

variable "is_enable_portworx" {
  default     = false
  type        = bool
  description = "Set to true to enable Portworx install"
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

##############################################################################
# ODF Variables
##############################################################################

variable "is_enable_odf" {
  default     = false
  type        = bool
  description = "Set to true to enable ODF install"
}

# Option required for Openshift 4.7 only
variable "monStorageClassName" {
  default     = "ibmc-vpc-block-metro-10iops-tier"
  type        = string
  description = "Enter the Block Storage for VPC storage class that you want to use to dynamically provision storage for the monitor pods. The default storage class is ibmc-vpc-block-metro-10iops-tier."
}

# Option required for Openshift 4.7 only
variable "monSize" {
  default     = "20Gi"
  type        = number
  description = "Enter the size of the Block Storage for VPC devices that you want to provision for the ODF monitor pods. The default setting 20Gi"
}

variable "osdStorageClassName" {
  default     = "ibmc-vpc-block-metro-10iops-tier"
  type        = string
  description = "Enter the Block Storage for VPC storage class that you want to use to dynamically provision storage for the OSD pods. The default storage class is ibmc-vpc-block-metro-10iops-tier"
}

variable "osdSize" {
  default     = "100Gi"
  type        = number
  description = "Enter the size of the Block Storage for VPC devices that you want to provision for the OSD pods. The default size is 250Gi"
}

variable "numOfOsd" {
  default     = 1
  type        = number
  description = "Enter the number of block storage device sets that you want to provision for ODF. A numOfOsd value of 1 provisions 1 device set which includes 3 block storage devices. The devices are provisioned evenly across your worker nodes. For more information, see https://cloud.ibm.com/docs/openshift?topic=openshift-ocs-storage-prep"
}

variable "billingType" {
  type        = string
  default     = "advanced"
  description = "Billing Type for your ODF deployment (`essentials` or `advanced`)."
}

variable "ocsUpgrade" {
  default     = false
  type        = bool
  description = "Enter true or false to upgrade the ODF operators. For initial deployment, leave this setting as false. The default setting is false"
}

variable "clusterEncryption" {
  default     = false
  type        = bool
  description = "Enter true or false to enable cluster encryption. The default setting is false"
}