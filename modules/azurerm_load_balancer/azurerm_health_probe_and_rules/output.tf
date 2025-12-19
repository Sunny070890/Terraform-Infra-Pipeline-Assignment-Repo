output "probe_ids" {
  description = "Map of Load Balancer probe IDs by key"
  value       = {
    for key, probe in azurerm_lb_probe.probe :
    key => probe.id
  }
}