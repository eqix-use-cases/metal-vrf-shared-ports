output "connection_string" {
  value = <<EOT
    curl -s "https://api.equinix.com/metal/v1/projects/${var.project_id}/connections" \
      -X POST \
      -H "Content-Type: application/json" \
      -H "X-Auth-Token: $AUTH_TOKEN" \
      --data '{
        "type":"${var.connection_type}",
        "name":"vc-${random_pet.this.id}",
        "metro":"${upper(var.metal_cluster.amsterdam1.metro)}",
        "service_token_type":"${var.service_token_type}",
        "redundancy":"${var.connection_redundancy}",
        "speed":"${var.connection_speed}",
        "vrfs":["${equinix_metal_vrf.this.id}","${equinix_metal_vrf.this.id}"]
      }'
    EOT
}


output "primary_vc_string" {
  value = <<EOT

    ATTENTION: Make sure you replace the missing variable before running the command

    curl -s "https://api.equinix.com/metal/v1/virtual-circuits/$PRIMARY_VC_UUID?include=vrf.metro" \
      -X PUT \
      -H "Content-Type: application/json" \
      -H "X-Auth-Token: $AUTH_TOKEN" \
      --data '{
        "peer_asn":"${var.peer_asn}",
        "subnet":"${var.peering_subnet_first}",
        "metal_ip":"${var.metal_peer_ip_first}",
        "customer_ip":"${var.customer_peer_ip_first}",
        "md5":"${var.bgp_password}"
      }'
  EOT
}

output "secondary_vc_string" {
  value = <<EOT

    ATTENTION: Make sure you replace the missing variable before running the command

    curl -s "https://api.equinix.com/metal/v1/virtual-circuits/$SECONDARY_VC_UUID" \
      -X PUT \
      -H "Content-Type: application/json" \
      -H "X-Auth-Token: $AUTH_TOKEN" \
      --data '{
        "peer_asn":"${var.peer_asn}",
        "subnet":"${var.peering_subnet_second}",
        "metal_ip":"${var.metal_peer_ip_second}",
        "customer_ip":"${var.customer_peer_ip_second}",
        "md5":"${var.bgp_password}"
      }'
  EOT
}
