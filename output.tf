output "portworx_is_ready" {
  depends_on = [
    ibm_resource_instance.portworx
  ]
  value = length(ibm_resource_instance.portworx) > 0 ? ibm_resource_instance.portworx.id : null
}

output "odf_is_ready" {
  depends_on = [
    null_resource.enable_odf
  ]
  value = length(null_resource.enable_odf) > 0 ? null_resource.enable_odf[0].id : null
}