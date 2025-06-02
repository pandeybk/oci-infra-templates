terraform {
  required_version = ">= 1.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.12.0"
    }
  }
}

resource "oci_core_image" "master" {
  count          = var.create_openshift_instances ? 1 : 0
  compartment_id = var.compartment_ocid
  display_name = "${var.image_name}-master"
  launch_mode    = !var.is_control_plane_iscsi_type && !var.is_compute_iscsi_type ? "PARAVIRTUALIZED" : "NATIVE"

  image_source_details {
    source_type = "objectStorageUri"
    source_uri  = var.openshift_master_image_source_uri

    source_image_type = "QCOW2"
  }
  defined_tags = var.defined_tags
}

resource "oci_core_image" "worker" {
  count          = var.create_openshift_instances ? 1 : 0
  compartment_id = var.compartment_ocid
  display_name = "${var.image_name}-worker"
  launch_mode    = !var.is_control_plane_iscsi_type && !var.is_compute_iscsi_type ? "PARAVIRTUALIZED" : "NATIVE"

  image_source_details {
    source_type = "objectStorageUri"
    source_uri  = var.openshift_worker_image_source_uri

    source_image_type = "QCOW2"
  }
  defined_tags = var.defined_tags
}

resource "oci_core_shape_management" "imaging_control_plane_shape" {
  count          = var.create_openshift_instances ? 1 : 0
  compartment_id = var.compartment_ocid
  image_id       = oci_core_image.master[0].id
  shape_name     = var.control_plane_shape
}

resource "oci_core_shape_management" "imaging_compute_shape" {
  count          = var.create_openshift_instances ? 1 : 0
  compartment_id = var.compartment_ocid
  image_id       = oci_core_image.worker[0].id
  shape_name     = var.compute_shape
}


resource "oci_core_compute_image_capability_schema" "openshift_image_capability_schema_master" {
  count                                               = var.create_openshift_instances ? 1 : 0
  compartment_id                                      = var.compartment_ocid
  compute_global_image_capability_schema_version_name = local.global_image_capability_schemas[0].current_version_name
  image_id                                            = oci_core_image.master[0].id
  schema_data                                         = merge(
    local.schema_firmware,
    local.schema_boot_volume_type,
    local.schema_launch_mode,
    local.schema_local_volume_data_type,
    local.schema_remote_volume_data_type,
    local.schema_storage_iscsi_multipath_device_supported
  )
  defined_tags = var.defined_tags
}

resource "oci_core_compute_image_capability_schema" "openshift_image_capability_schema_worker" {
  count                                               = var.create_openshift_instances ? 1 : 0
  compartment_id                                      = var.compartment_ocid
  compute_global_image_capability_schema_version_name = local.global_image_capability_schemas[0].current_version_name
  image_id                                            = oci_core_image.worker[0].id
  schema_data                                         = merge(
    local.schema_firmware,
    local.schema_boot_volume_type,
    local.schema_launch_mode,
    local.schema_local_volume_data_type,
    local.schema_remote_volume_data_type,
    local.schema_storage_iscsi_multipath_device_supported
  )
  defined_tags = var.defined_tags
}