Multi Instance AWS ECS Module 

Directory Structure 

Parent Directory ECS_main
|			
|
Main.tf
Backend.tf
Variable.tf
Provider.tf
|
|
         Subdirectory  multi_instance_ecs_module
        						|
						|	
						|
						variable.tf
						vpc.tf
						security group.tf
						loadbalancer.tf
						cluster.tf
						iamrole.tf
						autoscaling.tf
						mainecs.tf

Configuration info 

All the variable declaration in variable.tf in parent directory,
Provider , Backend and function declaration in parent directory , in order to decrease errors from variable declarations inside module directory .

Step 1 to create VPC

	//using az_count var in order to create two pub and two pvt subnets for two instances


		count             = var.az_count
  		cidr_block        = cidrsubnet(aws_vpc.test-vpc.cidr_block, 8, count.index)
  		availability_zone = data.aws_availability_zones.available.names[count.index]
  		vpc_id            = aws_vpc.test-vpc.id



Step 2 to create security group

      //two nos of security group needs to be created one for internal load balance and one for internet traffic 

      	1.
		resource "aws_security_group" "alb-sg" {
  		name        = "testapp-load-balancer-security-group"
  		description = "controls access to the ALB"
  		vpc_id      = aws_vpc.test-vpc.id
  		
  		2.
  		resource "aws_security_group" "ecs_sg" {
  		name        = "testapp-ecs-tasks-security-group"
  		description = "allow inbound access from the ALB only"
  		vpc_id      = aws_vpc.test-vpc.id


Step 3 to create load balancer defining target group 

		this steps includes Creating and associating the load balancer
		creating target group and target group policies 
		health check policies and defining the target .

Step 4 to create cluster group 

		Create a Cluster group for deploying the service 


Step 5 to create I am role 
		create an I am role for task execution 

Step 6 to create autoscaling 
		Create autoscaling group and associate services that you will create in next upcoming step. 
		define scaling dimensions and policies 

Step 7 to create main ecs task definition and ecs service .
        create Task definition and associated already created cluster family 
        i have used fargate 
        define your container details and attach network configurations 
        at last use container name , port and loadbalancer target group id for load balancing .
      

Thanks 