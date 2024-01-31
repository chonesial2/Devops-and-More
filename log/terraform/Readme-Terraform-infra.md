## _Mandatory Steps to initialize terraform cloud and AWS with each other_

1. First go to https://app.terraform.io

2. There you need to create a workspace and an orgsnization.

3. Once created you need to mention the same workspace and organisation in backend.tf.

4. Then set up the AWS credentials and region and provider in Provider.tf. This will help in set up of AWS.

5. Once this is complete , run the command "terraform init" and this will initalize the backend and sync the AWS with the terraform cloud.



## Main.tf

*This file basically contains the information about which cloud support we are required to use . For example,  it may be AWS or it may be Azure. And it also contains the region where we want to deploy the infrastructure.*

## Database.tf

*This file contains all the Database related subnet groups.
It also contains the security groups required for the databases as it is very important to keep the databases secure always.
It also contains the RDS cluster and the subnets related to it.
There is also an RDS Instance.*

## Backend.tf

*This file tells us how and where operations are to be performed. It also tells us where snapshots are stored.
There are two areas of Terraform's behavior that are determined by the backend.

Where state is stored.
Where operations are performed.*

## Variable.tf

*This file contains the variables that interprets in all kinds of deployements.
In order to change any infrastructure , we will only need to change the variables in this file. 
For example, it could be our enviroment , application name.* 

## Web.tf

*This file has the main infrastructure including Elastic Container Sertvice, Load balancer (its dependencies on s3 buckets) , also the target groups related to the load balancers.
However, this also includes the secret manager services also.*

##Output.tf
*This file gives us the output result including the URL and The databse Port.
Output values are like the return values of a Terraform module, and have several uses: A child module can use outputs to expose a subset of its resource attributes to a parent module. A root module can use outputs to print certain values in the CLI output after running terraform apply .*
