variable "project_id" {
  description = "Metal project ID"
  default     = ""
}

variable "metal_cluster" {
  type = map(object({
    plan             = string
    metro            = string
    operating_system = string
    billing_cycle    = string
    network_type     = string
    port_name        = string
    ip               = string
    netmask          = string
  }))
}


variable "vxlan" {
  type        = number
  description = "vlan for the servers"
  default     = 0
}

variable "metal_asn" {
  description = "ASN on the Metal side"
  default     = 0
  type        = number
}

variable "ip_ranges" {
  type        = list(any)
  default     = []
  description = "Input ip ranges for VRF"
}

// connections
variable "ip_block_type" {
  type    = string
  default = ""
}

variable "ip_block" {
  type    = string
  default = ""
}

variable "ip_block_cidr" {
  type    = number
  default = 0
}

variable "service_token_type" {
  type    = string
  default = ""
}

variable "connection_type" {
  type    = string
  default = ""
}

variable "connection_redundancy" {
  type    = string
  default = ""
}

variable "connection_speed" {
  type    = string
  default = ""
}

// peering
variable "peer_asn" {
  type    = number
  default = 0
}

variable "peering_subnet_first" {
  type    = string
  default = ""
}

variable "metal_peer_ip_first" {
  type    = string
  default = ""
}

variable "customer_peer_ip_first" {
  type    = string
  default = ""
}

variable "peering_subnet_second" {
  type    = string
  default = ""
}

variable "metal_peer_ip_second" {
  type    = string
  default = ""
}

variable "customer_peer_ip_second" {
  type    = string
  default = ""
}

variable "bgp_password" {
  type = string
}

// network edge
variable "notification_email" {
  type    = list(any)
  default = []
}

variable "route_os" {
  type    = string
  default = ""
}

variable "route_os_version" {
  type    = string
  default = ""
}

variable "package_code" {
  type    = string
  default = ""
}

variable "core_count" {
  type    = number
  default = 0
}

variable "term_length" {
  type    = number
  default = 0
}

variable "dc_code" {
  type    = string
  default = ""
}

variable "account_name" {
  type    = string
  default = ""
}
