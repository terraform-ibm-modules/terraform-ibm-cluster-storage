# Test ODF Terraform Module

## 1. Set up access to IBM Cloud

If running this module from your local terminal, you need to set the credentials to access IBM Cloud.

You can define the IBM Cloud credentials in the IBM provider block but it is recommended to pass them in as environment variables.

Go [here](../../CREDENTIALS.md) for details.

**NOTE**: These credentials are not required if running this Terraform code within an **IBM Cloud Schematics** workspace. They are automatically set from your account.

## 2. Test

### Using Terraform client

Follow these instructions to test the Terraform Module manually

Create the file `test.auto.tfvars` with the following input variables, these values are fake examples:

```hcl
is_enable_odf           = true
ibmcloud_api_key        = "<api-key>" // pragma: allowlist secret

// ODF parameters
cluster_id              = "<cluster-id>"
monStorageClassName     = "ibmc-vpc-block-metro-10iops-tier"
osdSize                 = 250
workerNodes             = "all"
ocsUpgrade              = false
monSize                 = 20
numOfOsd                = 1
osdStorageClassName     = "ibmc-vpc-block-metro-10iops-tier"
clusterEncryption       = false
```

These parameters are:

- `ibmcloud_api_key`: IBM Cloud Key needed to provision resources.
- `is_enable_odf`: Variable to enable install ODF
- `cluster_id`: Cluster ID of the OpenShift cluster where to install ODF
- `monStorageClassName`: Block Storage for VPC storage class that you want to use to dynamically provision storage for the monitor pods. The default storage class is ibmc-vpc-block-metro-10iops-tier
- `osdSize`: Size of the Block Storage for VPC devices that you want to provision for the OSD pods. The default size is 250Gi
- `workerNodes`: Worker nodes where you want to deploy ODF. You must have at least 3 worker nodes. The default setting is all. If you want to deploy ODF only on certain nodes, enter the IP addresses of the worker nodes in a comma-separated list without spaces, for example: XX.XXX.X.X,XX.XXX.X.X,XX.XXX.X.X
- `ocsUpgrade`: Variable to upgrade the ODF operators. For initial deployment, leave this setting as false. The default setting is false
- `monSize`: Size of the Block Storage for VPC devices that you want to provision for the ODF monitor pods. The default setting 20Gi
- `numOfOsd`: Number of block storage device sets that you want to provision for ODF. A numOfOsd value of 1 provisions 1 device set which includes 3 block storage devices. The devices are provisioned evenly across your worker nodes. For more information, see https://cloud.ibm.com/docs/openshift?topic=openshift-ocs-storage-prep
- `osdStorageClassName`: Block Storage for VPC storage class that you want to use to dynamically provision storage for the OSD pods. The default storage class is ibmc-vpc-block-metro-10iops-tier
- `clusterEncryption`: Enter true or false to enable cluster encryption. The default setting is false

Execute the following Terraform commands:

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

## 3. Verify

To verify installation on the Openshift cluster you need `oc`, then execute:

After the service shows as active in the IBM Cloud resource view, verify the deployment:

    ibmcloud oc cluster addon ls -c <cluster_name>

This should display something like the following:

    openshift-data-foundation                 4.7.0     Normal     Addon Ready

Verify that the ibm-ocs-operator-controller-manager-***** pod is running in the kube-system namespace.

    oc get pods -A | grep ibm-ocs-operator-controller-manager

This should produce output like:

    kube-system              ibm-ocs-operator-controller-manager-58fcf45bd6-68pq5              1/1     Running            0          5d22h

## 4. Clean up

When the cluster is no longer needed, run `terraform destroy` if this was created using your local Terraform client with `terraform apply`. 

If this cluster was created using `schematics`, just delete the schematics workspace and specify to delete all created resources.

<b>For ODF:</b>

To uninstall ODF and its dependencies from a cluster, execute the following commands:

While logged into the cluster

```bash
terraform destroy -target null_resource.enable_odf
```
This will disable the ODF on the cluster

Once this completes, execute: `terraform destroy` if this was create locally using Terraform or remove the Schematic's workspace.
