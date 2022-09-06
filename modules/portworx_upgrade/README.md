# Terraform module to upgrade a portworx storage with helm provider


#About Portworx Cloud Drive Support

- In cloud environments, Portworx can dynamically create disks based on an input disk template whenever a new instance spins up and use those disks for the Portworx cluster.
- Portworx fingerprints the disks and attaches them to an instance in the cluster. In this way an ephemeral instance gets its own identity.

Why would I need this?
- Users don’t have to manage the lifecycle of disks. Instead, they just have to provide disks specs and Portworx manages the disk lifecycle.
- When an instance terminates, the auto scaling group/user will add a new instance to the cluster. Portworx gracefully handles this scenario by re-attaching the disks to it and give a new instance the old identity. This ensures that the instance’s data is retained with zero storage downtime.

## Compatibility

This module is meant for use with Terraform >= 0.13.

## Usage

Example to upgrade portworx version on VPC cluster

```hcl
resource "helm_release" "px" {
  repository        = "https://raw.githubusercontent.com/IBM/charts/master/repo/community"
  chart            = "portworx"
  name              = "portworx"
  reuse_values      = true
  dependency_update = true
  force_update      = true
  recreate_pods     = false
  wait              = true
  max_history       = 1
}

```

## Input Variables

| Name                           | Description                                                                                                                                                                                                                | Default | Required |
| ------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | -------- |
| `kube_config_path`             | This is the path to the kube config                                          |  `.kube/config` | Yes       |
## Requirements

### Terraform plugins

- [Terraform](https://www.terraform.io/downloads.html) >= 0.13
- [terraform-provider-ibm](https://github.com/IBM-Cloud/terraform-provider-ibm)
- [Helm](https://helm.sh/docs/intro/install/)

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

Before executing the other Terraform commands listed below, please perform the Terraform import command first:
```bash
terraform init
terraform import helm_release.px default/portworx
```

```bash
terraform plan
terraform apply -auto-approve

All optional parameters by default will be set to null in respective example's varaible.tf file. If user wants to configure any optional paramter he has overwrite the default value.

```

## Note

All optional fields should be given value `null` in respective resource variable.tf file. User can configure the same by overwriting with appropriate values.
