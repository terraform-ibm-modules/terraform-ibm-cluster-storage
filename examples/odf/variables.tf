variable "is_enable_odf" {
    default = true
    type = bool
    description = "If set to true installs ODF on the given cluster"
}

variable "ibmcloud_api_key" {
  description = "Get the ibmcloud api key from https://cloud.ibm.com/iam/apikeys"
}

variable "kube_config_path" {
  description = "Path to the k8s config file: ex `~/.kube/config`"
  type        = string
  default     = "/tmp"
}

variable "cluster" {
    description = "The cluster where we are going to enable ODF"
}

variable "region" {
    description = "The region ODF will be installed in: us-south, us-east, eu-gb, eu-de, jp-tok, au-syd, etc.."
}

variable "resource_group_name" {
    default = "default"
    type = string
    description = "Resource Group in your account. List all available resource groups with: ibmcloud resource groups"
}

variable "roks_version" {
    default = "4.7"
    type = "string"
  description = "Roks version of the cluster where ODF will be installed. For this script it needs to be 4.7 and up"
}