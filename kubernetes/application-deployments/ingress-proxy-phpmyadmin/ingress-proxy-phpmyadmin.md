**Ingress proxy for phpmyadmin**


1. Setup k8s cluster (in this testing used microk8s)
1. Enable ingress controller by running **microk8s enable ingress** command it will provide the outside access to the cluster
1. Deploy mysql in k8s for testing
1. Deploy phpmyadmin in k8s to manage mysql database
1. Create the ingress for phpmyadmin and define the host name there and deploy ingress
1. Now we need to take the ip of microk8s cluster by running **kubectl cluster-info** command and point that ip to the host (which we are using in ingress file) in /etc/hosts for testing and try to access it by using the domain 
