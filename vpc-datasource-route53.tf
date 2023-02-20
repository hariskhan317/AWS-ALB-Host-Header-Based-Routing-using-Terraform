data "aws_route53_zone" "mydomain" {
  name         = "mydevopsample.com." 
}

// zone id
output "domain_zone_id" {
  value       = data.aws_route53_zone.mydomain.zone_id
  description = "My domain zone id"
}

// zone name
output "domain_zone_namee" {
  value       = data.aws_route53_zone.mydomain.name
  description = "My domain zone id"
}
