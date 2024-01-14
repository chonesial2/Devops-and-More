// Registry

resource "aws_ecr_repository" "web" {
  name                     = join("-", [ var.application_name, var.environment, "web" ])
  image_tag_mutability     = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  // tags = {
  //   Name           = join("-", [ var.application_name, var.environment, "web" ])
  //   environment    = var.environment
  //   maintainer     = var.maintainer
  // }

}


// Load Balancer

resource "aws_s3_bucket" "web-logs" {
  bucket = join("-", [ var.application_name, var.environment, "logs" ])
  acl    = "private"

  tags = {
    Name           = join("-", [ var.application_name, var.environment, "web", "logs" ])
    environment    = var.environment
    maintainer     = var.maintainer
  }
}

// https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html#d0e10520.%20variable
resource "aws_s3_bucket_policy" "web-logs" {
  bucket = join("-", [ var.application_name, var.environment, "logs" ])
  policy = jsonencode(
              {
                Id        = "LB-Logs-Allow-Policy"
                Statement = [
                    {
                        Action    = "s3:PutObject"
                        Effect    = "Allow"
                        Principal = {
                                      AWS = join(":", [ "arn:aws:iam:", var.alb_ac_id, "root" ])
                                    }
                        
                        Resource  = join("/", [ 
                                        aws_s3_bucket.web-logs.arn,
                                        join("-", [ var.application_name, var.environment, "web" ]), 
                                        "AWSLogs",
                                        data.aws_caller_identity.current.account_id,
                                        "*"
                                      ])
                        Sid       = "Load Balancer Account Access Web"
                    },
                    {
                        Action    = "s3:PutObject"
                        Condition = {
                                      StringEquals = {
                                          "s3:x-amz-acl" = "bucket-owner-full-control"
                                        }
                                    }
                        Effect    = "Allow"
                        Principal = {
                                      Service = "delivery.logs.amazonaws.com"
                                    }
                        
                        Resource  = join("/", [ 
                                        aws_s3_bucket.web-logs.arn,
                                        join("-", [ var.application_name, var.environment, "web" ]), 
                                        "AWSLogs",
                                        data.aws_caller_identity.current.account_id,
                                        "*"
                                      ])
                        Sid       = "AWSLogDeliveryWrite Web"
                    },
                    {
                        Action    = "s3:GetBucketAcl"
                        Effect    = "Allow"
                        Principal = {
                                      Service = "delivery.logs.amazonaws.com"
                                    }
                        
                        Resource  = aws_s3_bucket.web-logs.arn
                        Sid       = "AWSLogDeliveryAclCheck"
                    },
                  ]
                Version   = "2012-10-17"
              }
          )

  depends_on  = [ aws_s3_bucket.web-logs ]
}



resource "aws_lb" "web" {
  name                = join("-", [ var.application_name, var.environment, "web" ])
  internal            = false
  load_balancer_type  = "application"
  security_groups     = [ data.terraform_remote_state.core.outputs.sg-allow-public-web-id ]
  
  subnets             = [
                          data.terraform_remote_state.core.outputs.subnet-id-public-01,
                          data.terraform_remote_state.core.outputs.subnet-id-public-02,
                          data.terraform_remote_state.core.outputs.subnet-id-public-03,
                        ]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.web-logs.bucket
    prefix  = join("-", [ var.application_name, var.environment, "web" ])
    enabled = true
  }


  depends_on          = [ aws_s3_bucket_policy.web-logs ]

  tags = {
    Name           = join("-", [ var.application_name, var.environment, "web" ])
    environment    = var.environment
    maintainer     = var.maintainer
  }
}

resource "aws_lb_target_group" "web" {
  name     = join("-", [ var.application_name, var.environment, "web", "http" ])
  port     = 80
  protocol = "HTTP"
  target_type    = "ip"
  vpc_id   = data.terraform_remote_state.core.outputs.vpc-main-id

  depends_on          = [ aws_lb.web ]
}
 
// resource "aws_lb_listener" "https" {
//   load_balancer_arn = aws_lb.web.arn
//   port              = "443"
//   protocol          = "HTTPS"
//   ssl_policy        = "ELBSecurityPolicy-2016-08"
//   certificate_arn   = "arn:aws:acm:eu-west-1:031789349449:certificate/9b0875fa-5e43-476f-889e-2b991a838575"
//   depends_on         = [ aws_lb.web, aws_lb_target_group.web ]
//   default_action {
//     type             = "forward"
//     target_group_arn = aws_lb_target_group.web.arn
//   }
// }

resource "aws_lb_listener" "http"{
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"


  // Change it if we are using HTTPS

  // default_action {
  //   type = "redirect"

  //   redirect {
  //     port        = "443"
  //     protocol    = "HTTPS"
  //     status_code = "HTTP_301"
  //   }
  // }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_ecs_cluster" "web" {
  name               = join("-", [ var.application_name, var.environment ])

  capacity_providers = [ "FARGATE", "FARGATE_SPOT" ]

  setting {
      name  = "containerInsights"
      value = "enabled"
  }

  tags = {
    Name           = join("-", [ var.application_name, var.environment ])
    environment    = var.environment
    maintainer     = var.maintainer
  }

}

resource "aws_ecs_task_definition" "web" {
  family                     = join("-", [ var.application_name, var.environment, "web" ])

  // Task definition file might be created dynamically locally
  container_definitions      = file("task-definitions/demo-web.json")

  requires_compatibilities   = [ "FARGATE" ]
  network_mode               = "awsvpc"
  cpu                        = 1024
  memory                     = 2048

  execution_role_arn         = join(":", [ "arn:aws:iam:", var.aws_account_id, "role/ecsTaskExecutionRole" ])

  task_role_arn         = join(":", [ "arn:aws:iam:", var.aws_account_id, "role/ecsTaskExecutionRole" ])
  
  // placement_constraints {
  //   type       = "memberOf"
  //   expression = "attribute:ecs.availability-zone in [eu-west-1a, eu-west-1b]"
  // }

  tags = {
    Name           = join("-", [ var.application_name, var.environment ])
    environment    = var.environment
    maintainer     = var.maintainer
  }
}


resource "aws_ecs_service" "web" {
  name                = join("-", [ var.application_name, var.environment, "web" ])
  cluster             = aws_ecs_cluster.web.id
  task_definition     = aws_ecs_task_definition.web.arn
  desired_count       = 1
  // scheduling_strategy = "DAEMON"

  launch_type         = "FARGATE"

  network_configuration {
    security_groups = [
                        data.terraform_remote_state.core.outputs.sg-testing-mode-id
                      ]
    subnets         = [
                        data.terraform_remote_state.core.outputs.subnet-id-private-01,
                        data.terraform_remote_state.core.outputs.subnet-id-private-02,
                        data.terraform_remote_state.core.outputs.subnet-id-private-03,
                      ]
  }

  load_balancer {
    // target_group_arn = "${aws_lb_target_group.foo.arn}"
    target_group_arn = aws_lb_target_group.web.arn
    container_name   = join("-", [ var.application_name, var.environment, "web" ])
    container_port   = 80
  }


  depends_on          = [ aws_ecs_cluster.web, aws_ecs_task_definition.web, aws_lb_target_group.web, aws_lb_listener.http ]

  // Change it if we are using HTTPS
  // aws_lb_listener.https


  // tags = {
  //   Name           = join("-", [ var.application_name, var.environment ])
  //   environment    = var.environment
  //   maintainer     = var.maintainer
  // }
}

