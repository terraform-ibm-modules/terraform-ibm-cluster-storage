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

variable "region" {
  description = "The region ODF will be installed in: us-south, us-east, eu-gb, eu-de, jp-tok, au-syd, etc.."
}