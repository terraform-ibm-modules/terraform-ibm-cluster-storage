# Terraform template to install Portworx on a VPC cluster

This Terraform template installs the **Portworx Service** on VPC cluster on an IBM Cloud.


### Provisioning the Portworx on ROKS cluster

```hcl
module "portworx" {
  source = "./../.."

  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
  resource_group   = var.resource_group_name
  cluster          = var.cluster
  unique_id        = var.unique_id
  kube_config_path = data.ibm_container_cluster_config.cluster_config.config_file_path

  // These credentials have been hard-coded because the 'Databases for etcd' service instance is not configured to have a publicly accessible endpoint by default.
  // You may override these for additional security.
  create_external_etcd = var.create_external_etcd
  etcd_username        = var.etcd_username
  etcd_password        = var.etcd_password
  etcd_secret_name     = var.etcd_secret_name

}
```

## Input Variables

| Name                           | Description                                                                                                                                                                                                                | Default | Required |
| ------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | -------- |
| `ibmcloud_api_key`             | This requires an ibmcloud api key found here: `https://cloud.ibm.com/iam/apikeys`    |         | Yes       |
| `kube_config_path`             | This is the path to the kube config                                          |  `.kube/config` | Yes       |
| `install_storage`              | If set to `false` does not install storage and attach the volumes to the worker nodes. Enabled by default  |  `true` | Yes      |
| `capacity`             | Sets the capacity of the volume in GBs. |   `200`    | Yes      |
| `profile`              | The is the storage profile used for creating storage. If this is set to a custom profile, you must update the `storage_iops` |   `10iops-tier`    | Yes      |
| `resource_group_name`          | The resource group name where the cluster is housed                                  |         | Yes      |
| `region`                       | The region that resources will be provisioned in. Ex: `"us-east"` `"us-south"` etc.  |         | Yes      |
| `cluster`                   | The name of the cluster created |  | Yes       |
| `unique_id`                    | The id of the portworx-service  |  | Yes       |
| `create_external_etcd`         | Set this value to `true` or `false` to create an external etcd | `false` | Yes |
| `etcd_username`                | Username needed for etcd                         | `portworxuser`     | yes |
| `etcd_password`                | Password needed for etcd                         | `portworxpassword` | Yes |
| `etcd_secret_name`             | Etcd secret name, do not change it from default  | `px-etcd-certs`    | Yes |
| `cpu_allocation_count`         | Enables and allocates the number of specified dedicated cores to your deployment                         | 9     | no |
| `disk_allocation_mb`           | The amount of disk space for the database, split across all members                         | 393216 | no |
| `memory_allocation_mb`         | The amount of memory in megabytes for the database, split across all members.  | 24576    | no |
| `db_plan`                | The name of the service plan that you choose for db instance.                        | `standard`     | yes |
| `service_endpoints`            | Specify whether you want to enable the public, private, or both service endpoints.                          | `public` | no |
| `db_version`             | The version of the database to be provisioned. | `3.3`    | no |
| `kubernetes_secret_namespace` | Name of the namespace                        | `kube-system`     | yes |
| `pwx_plan`                | Portworx plan type                        | `px-enterprise` | Yes |
| `cluster_name`             | Name of the cluster  | `pwx`    | Yes |
| `secret_type`             | secret type  | `k8s`    | no |


## Executing the Terraform Script

Run the following commands to execute the TF script (containing the modules to create/use ROKS and Portworx). Execution may take about 5-15 minutes:

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

## Clean up

To remove Portworx and Storage from a cluster, execute the following command:

Note: Please execute the below command from the examples directory

```bash
terraform destroy
```