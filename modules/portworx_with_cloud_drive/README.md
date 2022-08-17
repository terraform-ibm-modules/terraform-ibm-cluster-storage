# Terraform module to create a portworx storage with cloud drive support


#About Portworx Cloud Drive Support

- In cloud environments, Portworx can dynamically create disks based on an input disk template whenever a new instance spins up and use those disks for the Portworx cluster.
- Portworx fingerprints the disks and attaches them to an instance in the cluster. In this way an ephemeral instance gets its own identity.

Why would I need this?
- Users don’t have to manage the lifecycle of disks. Instead, they just have to provide disks specs and Portworx manages the disk lifecycle.
- When an instance terminates, the auto scaling group/user will add a new instance to the cluster. Portworx gracefully handles this scenario by re-attaching the disks to it and give a new instance the old identity. This ensures that the instance’s data is retained with zero storage downtime.

## Compatibility

This module is meant for use with Terraform >= 0.13.

## Usage

Example to create Software Defined Storage(SDS) with portworx on VPC cluster

```hcl
module "portworx" {
  source = "./../modules/portworx_with_cloud_drive"

  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
  resource_group   = var.resource_group_name
  cluster          = var.cluster
  unique_id        = var.unique_id
  kube_config_path = data.ibm_container_cluster_config.cluster_config.config_file_path

  // cloud drives parameters
  max_storage_node_per_zone=var.max_storage_node_per_zone
  num_cloud_drives=var.num_cloud_drives
  cloud_drives_sizes=var.cloud_drives_sizes
  storage_class = var.storage_class

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
| `cloud_drive`             | If cloud drive support needs to be enabled, this should be set to true | Yes  | Yes |
| `num_cloud_drives`        | No of cloud drives or disks to be attached to each of the workers in the cluster where Portworx is going to be installed(maximum value is 3) | 1  | Yes |
| `storage_class`        | List of Storage Classes that will be used to provision the cloud drives | `["ibmc-vpc-block-10iops-tier","",""]`  | Yes |
| `cloud_drives_sizes`      | Sizes of the cloud drives that are going to be provisioned, no of cloud drive sizes will vary based on the no of cloud drives | `[100,0,0]`  | Yes |
| `max_storage_node_per_zone` | maximum no of storage nodes where the disks should be provisioned automatically within a zone, remaining nodes will be storage less nodes for Portworx | 1  | Yes |
| `px_pvc_deletion` | Set this value to `true` or `false` to delete the portworx pvc in cleanup process  | `false` | Yes |

## Requirements

### Terraform plugins

- [Terraform](https://www.terraform.io/downloads.html) >= 0.13
- [terraform-provider-ibm](https://github.com/IBM-Cloud/terraform-provider-ibm)
- [Helm](https://helm.sh/docs/intro/install/)
- Curl

## Install

### Terraform

Be sure you have the correct Terraform version (>= 0.13), you can choose the binary here:
- https://releases.hashicorp.com/terraform/

### Terraform plugins

Be sure you have the compiled plugins on $HOME/.terraform.d/plugins/

- [terraform-provider-ibm](https://github.com/IBM-Cloud/terraform-provider-ibm)

### Pre-commit Hooks

Run the following command to execute the pre-commit hooks defined in .pre-commit-config.yaml file

pre-commit run -a

We can install pre-coomit tool using

pip install pre-commit

      or

pip3 install pre-commit

### Detect Secret hook

Used to detect secrets within a code base.

To create a secret baseline file run following command

```
detect-secrets scan --update .secrets.baseline
```

While running the pre-commit hook, if you encounter an error like

```
WARNING: You are running an outdated version of detect-secrets.
Your version: 0.13.1+ibm.27.dss
Latest version: 0.13.1+ibm.46.dss
See upgrade guide at https://ibm.biz/detect-secrets-how-to-upgrade
```

run below command

```
pre-commit autoupdate
```
which upgrades all the pre-commit hooks present in .pre-commit.yaml file.

## Executing the Terraform Script

Run the following commands to execute the TF script (containing the modules to create/use ROKS and Portworx). Execution may take about 5-15 minutes:

Note:
- Export IC_API_KEY="XXXXX"
- Change the inputs.tfvars, If you don't really want to use the default values.
- Obtain the list of storageclasses after executing `script_sc.sh` and modify storageclass's default values in inputs.tfvars

```bash
terraform init
terraform plan -var-file=inputs.tfvars
terraform apply -auto-approve -var-file=inputs.tfvars

All optional parameters by default will be set to null in respective example's varaible.tf file. If user wants to configure any optional paramter he has overwrite the default value.

## Clean up

To remove Portworx and Storage from a cluster, execute the following command:

```bash
terraform destroy
```

## Note

All optional fields should be given value `null` in respective resource varaible.tf file. User can configure the same by overwriting with appropriate values.
