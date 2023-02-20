module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name  = trimsuffix(data.aws_route53_zone.mydomain.name,".")
  zone_id      = data.aws_route53_zone.mydomain.zone_id

  subject_alternative_names = [
    "*.mydevopsample.com"
  ]

  tags = {
    Name = "mydevopsample.com"
  }
}

// output
output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = module.acm.acm_certificate_arn
}