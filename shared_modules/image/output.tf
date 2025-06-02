output "op_image_openshift_master_image" {
  value = try(oci_core_image.master[0].id, null)
}

output "op_image_openshift_worker_image" {
  value = try(oci_core_image.worker[0].id, null)
}
