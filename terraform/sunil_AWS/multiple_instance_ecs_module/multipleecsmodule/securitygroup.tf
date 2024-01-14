//Security Group for ECS other resources such as alb etc.


# security group creation and attcahing in ecs, alb etc

# ALB Security Group: Edit to restrict access to the application

//Mention Name and association

resource "aws_security_group" "alb-sg" {
  name        = "testapp-load-balancer-security-group"
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.test-vpc.id

//Mention inbound Rules 

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = ["0.0.0.0/0"]
  }

//Mention Outbound Rules 

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//This Security Group for internet traffic .

# this security group for ecs - Traffic to the ECS cluster should only come from the ALB
//Menton name and association

resource "aws_security_group" "ecs_sg" {
  name        = "testapp-ecs-tasks-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.test-vpc.id

//inbound Rules

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.alb-sg.id]
  }

//outbound Rules

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

