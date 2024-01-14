
//create cluster after creating alb group and before creating auto scaling

resource "aws_ecs_cluster" "test-cluster" {
  name = "myapp-cluster"

depends_on = [ aws_alb.alb]

}



