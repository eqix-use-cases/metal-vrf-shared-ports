// hostname
resource "random_pet" "this" {
  length = 2
}

// ssh keys
module "key" {
  source     = "git::github.com/andrewpopa/terraform-metal-project-ssh-key"
  project_id = var.project_id
}

// metal devices
resource "equinix_metal_device" "this" {
  for_each            = var.metal_cluster
  hostname            = "${random_pet.this.id}-${each.key}"
  plan                = each.value.plan
  metro               = each.value.metro
  operating_system    = each.value.operating_system
  billing_cycle       = each.value.billing_cycle
  tags                = ["${random_pet.this.id}-${each.value.metro}"]
  project_id          = var.project_id
  project_ssh_key_ids = [module.key.id]
  user_data = templatefile("${path.module}/bootstrap/vlans.sh", {
    VLAN    = var.vxlan
    IP      = each.value.ip
    NETMASK = each.value.netmask
  })
}

// vlan for metal
resource "equinix_metal_vlan" "this" {
  // deployment is in one metro, address the value directly from object
  metro      = var.metal_cluster.amsterdam1.metro
  vxlan      = var.vxlan
  project_id = var.project_id
}

// network type on each device
resource "equinix_metal_device_network_type" "this" {
  for_each  = var.metal_cluster
  device_id = equinix_metal_device.this["${each.key}"].id
  type      = each.value.network_type // layer3 interface
}

// attach device
resource "equinix_metal_port_vlan_attachment" "this" {
  for_each  = var.metal_cluster
  device_id = equinix_metal_device_network_type.this["${each.key}"].id
  port_name = each.value.port_name
  vlan_vnid = var.vxlan
}

// vrf
resource "equinix_metal_vrf" "this" {
  description = "VRF with ASN 65100 and a pool of address space that includes a subnet for your BGP and subnets for each of your Metal Gateways"
  name        = random_pet.this.id
  metro       = var.metal_cluster.amsterdam1.metro
  project_id  = var.project_id
  local_asn   = var.metal_asn
  ip_ranges   = var.ip_ranges
}

resource "equinix_metal_reserved_ip_block" "this" {
  description = "Reserved gateway IP block (192.168.105.0/24) taken from one of the ranges in the VRF's pool of address space ip_ranges. "
  project_id  = var.project_id
  metro       = var.metal_cluster.amsterdam1.metro
  type        = var.ip_block_type
  vrf_id      = equinix_metal_vrf.this.id
  cidr        = var.ip_block_cidr
  network     = var.ip_block
}

resource "equinix_metal_gateway" "this" {
  project_id        = var.project_id
  vlan_id           = equinix_metal_vlan.this.id
  ip_reservation_id = equinix_metal_reserved_ip_block.this.id
}

// virtual circuits
