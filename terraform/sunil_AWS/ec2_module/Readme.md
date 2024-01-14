Terraform Module for Ec2 instance


Directory Structure

ParentDirectory ( newecs )
                |
                Content of Parent Directory
                 |   
 	        ec2instance.tf

                |
                 ec2module (module directory)
                                 |
                               Content of ec2module directory
                                  |
                                Variable.tf
				main.tf
				output.tf
				ec2.tf
				backend.tf

Configuration Details

-VPC is Default

-Security Group details are defined in main.tf

-Ec2instance.tf is the root tf file for passing module details and variable

-Name of the instance is declared in ec2.tf.

Steps to configure

Declare preferred values in ec2instance.tf in root directory

Region
Access keys
Secret access keys
Ami details id
Instance type size
Cloud organisation provider details
Other preferred details

Pass any new variable through variable.tf

Run terraform init
Terraform plan
Terraform apply .

Thanks
