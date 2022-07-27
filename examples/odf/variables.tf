variable "is_enable_odf" {
  default     = true
  type        = bool
  description = "If set to true installs ODF on the given cluster"
}

variable "ibmcloud_api_key" {
  description = "Get the ibmcloud api key from https://cloud.ibm.com/iam/apikeys"
}

variable "cluster" {
  description = "The cluster where we are going to enable ODF"
}

variable "monStorageClassName" {
  default     = "ibmc-vpc-block-metro-10iops-tier"
  type        = string
  description = "Enter the Block Storage for VPC storage class that you want to use to dynamically provision storage for the monitor pods. The default storage class is ibmc-vpc-block-metro-10iops-tier."
}

variable "osdSize" {
  default     = 250 // 250Gi
  type        = number
  description = "Enter the size of the Block Storage for VPC devices that you want to provision for the OSD pods. The default size is 250Gi"
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

variable "monSize" {
  default     = 20 // 20Gi
  type        = number
  description = "Enter the size of the Block Storage for VPC devices that you want to provision for the ODF monitor pods. The default setting 20Gi"
}

variable "numOfOsd" {
  default     = 1
  type        = number
  description = "Enter the number of block storage device sets that you want to provision for ODF. A numOfOsd value of 1 provisions 1 device set which includes 3 block storage devices. The devices are provisioned evenly across your worker nodes. For more information, see https://cloud.ibm.com/docs/openshift?topic=openshift-ocs-storage-prep"
}

variable "osdStorageClassName" {
  default     = "ibmc-vpc-block-metro-10iops-tier"
  type        = string
  description = "Enter the Block Storage for VPC storage class that you want to use to dynamically provision storage for the OSD pods. The default storage class is ibmc-vpc-block-metro-10iops-tier"
}

variable "clusterEncryption" {
  default     = false
  type        = bool
  description = "Enter true or false to enable cluster encryption. The default setting is false"
}

#################################

variable "region" {
  description = "The region of the cluster ODF will be installed on: us-south, us-east, eu-gb, eu-de, jp-tok, au-syd, etc."
  default     = "us-south"
}

variable "resource_group_name" {
  description = "Resource group of existing cluster"
  type        = string
  default     = "Default"
}

variable "kube_config_path" {
  description = "Directory to store the kubeconfig file. If running on Schematics, use `/tmp/.schematics/.kube/config`"
  type        = string
  default     = "./.kube/config"
}

variable "roks_version" {
  type        = string
  description = "ROKS Cluster version (4.7 or higher)"
}