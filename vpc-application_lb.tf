module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"
    # insert the 5 required variables here
      name = "my-alb"
    load_balancer_type = "application" 
    vpc_id = module.vpc.vpc_id
    subnets = [
        module.vpc.public_subnets[0],
        module.vpc.public_subnets[1]
    ]
    security_groups = [module.sg_elb.security_group_id] 
    # HTTP Listener - HTTP to HTTPS Redirect
    http_tcp_listeners = [{
        port               = 80
        protocol           = "HTTP"
        action_type = "redirect"
        redirect = {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
        }
    }] 
    // target groups
    target_groups = [{
        //  targetgroup for app1
        name_prefix      = "app1-"
        backend_protocol = "HTTP"
        backend_port     = 80
        target_type      = "instance"
        health_check = {
            enabled             = true
            interval            = 30
            path                = "/app1/index.html"
            port                = "traffic-port"
            healthy_threshold   = 3
            unhealthy_threshold = 3
            timeout             = 6
            protocol            = "HTTP"
            matcher             = "200-399"
        }
        targets = {
            my_app1_vm1  = {
                target_id = element([for instance in module.ec2_instance_private_app1: instance.id],0)
                port = 80 }
            my_app1_vm2 = {
                target_id = element([for instance in module.ec2_instance_private_app1: instance.id],1)
                port = 80 }
        }
    },{    // target group app2 
        name_prefix      = "app2-"
        backend_protocol = "HTTP"
        backend_port     = 80
        target_type      = "instance"
        health_check = {
            enabled             = true
            interval            = 30
            path                = "/app2/index.html"
            port                = "traffic-port"
            healthy_threshold   = 3
            unhealthy_threshold = 3
            timeout             = 6
            protocol            = "HTTP"
            matcher             = "200-399"
        }
        targets = {
            my_app1_vm1  = {
                target_id = element([for instance in module.ec2_instance_private_app2: instance.id],0)
                port = 80 }
            my_app1_vm2 = {
                target_id = element([for instance in module.ec2_instance_private_app2: instance.id],1)
                port = 80 }
        }
    }]

    # HTTPS Listener
    https_listeners = [{
        port               = 443
        protocol           = "HTTPS"
        certificate_arn    = module.acm.acm_certificate_arn
            fixed_response = {
            content_type = "text/plain"
            message_body = "Fixed message"
            status_code  = "200"
        }
    }]
    // https listner rule
    https_listener_rules = [{
        // https listner rule for app1
        https_listener_index = 0
        actions = [{
            type               = "forward"
            target_group_index = 0
        }]
        conditions = [{
            path_patterns = ["/app1*"]
        }]
    },{
        // https listner rule for app2
        https_listener_index = 0
        actions = [{
            type               = "forward"
            target_group_index = 1
        }]
        conditions = [{
            path_patterns = ["/app2*"]
        }]
    }]
}