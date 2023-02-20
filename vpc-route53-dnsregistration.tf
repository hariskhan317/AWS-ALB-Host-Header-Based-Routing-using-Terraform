resource "aws_route53_record" "app_dns" {
    zone_id = data.aws_route53_zone.mydomain.zone_id
    name    = "app.mydevopsample.com"
    type    = "A"
    alias {
        name                   = module.alb.lb_dns_name
        zone_id                = module.alb.lb_zone_id
        evaluate_target_health = true
    }
}
// app1
resource "aws_route53_record" "app1_dns" {
    zone_id = data.aws_route53_zone.mydomain.zone_id
    name    = var.app1_dns_name
    type    = "A"
    alias {
        name                   = module.alb.lb_dns_name
        zone_id                = module.alb.lb_zone_id
        evaluate_target_health = true
    }
}
// app2
resource "aws_route53_record" "app2_dns" {
    zone_id = data.aws_route53_zone.mydomain.zone_id
    name    = var.app2_dns_name
    type    = "A"
    alias {
        name                   = module.alb.lb_dns_name
        zone_id                = module.alb.lb_zone_id
        evaluate_target_health = true
    }
}