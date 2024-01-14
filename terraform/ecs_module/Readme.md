Terraform Ecs Module 
Directory Structure 

ParentDirectory ( ECS )
                |
                Content of Parent Directory 
                 |   
 	        clusters.tf

                |
                 ecsmodule (module directory)
                                 |
                               Content of ecsmodule directory 
                                  |
                                Variable.tf
				main.tf
				output.tf
				backend.tf

Configuration Details 

All the variables and module declaration in clusters.tf preset at parent directory 
I am running ecs without declaring VPC, Security group, I am role and load balancer 
We can add them by describing resources inside module directory I.e ecsmodule.

Variables to pass 

 organization = var.organization.     //Organization name 
     family = var.family  		    // Cluster family name 
    contname = var.contname	   // Container name (in this case we are using only one container )
    imagename = var.imagename   // Image name (Httpd in this case)
    
Main.tf inside ecsmodule directory contains resource creation syntaxes 

Such as : cluster family , task definition and services 

:In this case the cluster family is created and a task definition is produced with minimum hardware configuration and an httpd service is deployed 

Output file is used to output the name of Resources . 

Thanks 
