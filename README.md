##########################################
# USING TERRAFORM SCRIPT
##########################################

## Download terraform binary
- location: https://www.terraform.io/downloads.html
- put the downloaded binary in path
- $ terraform --version

## Build docker container using Terraform script
- $ cd terraform-docker
- $ terraform init
- $ terraform plan (to view what will happen whey applied)
- $ terraform apply (apply the change)
    - Verify that docker container has been created by visiting http://localhost:8000 works
- terraform destroy (destroy whatever had been applied previously)

## Build Azure infrastructure with AKS for Camel-K using terraform
The required terraform script (main.tf) is inside terraform-azure folder
- $ cd terraform-azure
- $ az login
- $ cd learn-terraform-azure
- $ terraform init
- $ terraform plan
- $ terraform apply
- $ terraform show
- $ terraform state list
- $ terraform destroy (This will destroy everything that is created using main.tf)

## Get credential which will be stored in ~/.kube/config
- az aks get-credentials --resource-group camelk-demo-resources  --name camelk-demo-aks

## Check kube config
- $ kubectl config view 
    - token : <TOKEN>
- $  az aks browse --resource-group camelk-demo-resources --name camelk-demo-aks

## Login to azure portal UI and enable access key to ACR, it will generate user name and password
    username: CamelkDemoContainerRegistry
    password: <PWD>
    
## Login to Azure Container Registry
- az acr login --name CamelkDemoContainerRegistry --resource-group camelk-demo-resources --username CamelkDemoContainerRegistry --password <PWD>

## Update ask with newly created ACR (we should put this inside main.tf)
- $ az aks update -n camelk-demo-aks -g camelk-demo-resources --attach-acr CamelkDemoContainerRegistry

## Create namespace
- kubectl create namespace camel-basic
- kubectl config set-context --current --namespace=camel-basic

## Install Camel K in kubernetes
- kamel install --registry camelkdemocontainerregistry.azurecr.io --build-publish-strategy=Spectrum  --registry-auth-username CamelkDemoContainerRegistry --registry-auth-password <PWD> --force

## Run camel k application
- kamel run helloworld.groovy --dev
- or kamel run HelloWorld.java --dev
- kubectl get integrations
- kamel run helloworld.groovy
- or kamel run HelloWorld.java
- kamel log helloworld
- kamel delete helloworld

## Fix as follows, if pod/service are empty inside aks dashboard
- kubectl delete clusterrolebinding kubernetes-dashboard
- kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard --user=clusterUser


##########################################
# USING AZURE CLI
##########################################
## Login to Azure
- az login 

## Create resource group using CLI
- az group create --name camelk-demo-resources --location eastus

## Create azure container registry using "acr create"
- az acr create --resource-group camelk-demo-resources  --name CamelkDemoContainerRegistry --sku Basic

## Login to azure portal and enable access key to ACR, it will generate user name and password
    - username: CamelkDemoContainerRegistry
    - password: <PWD>
    
## Login to Azure Container Registry
- az acr login --name CamelkDemoContainerRegistry --resource-group camelk-demo-resources --username CamelkDemoContainerRegistry --password <PWD>

## Create an AKS cluster with ACR integration
- az aks create -n camelk-demo-aks -g camelk-demo-resources --generate-ssh-keys --attach-acr CamelkDemoContainerRegistry

## Update it later if needed
- az aks update -n camelk-demo-aks -g camelk-demo-resources --attach-acr CamelkDemoContainerRegistry

## Get credential which will be stored in ~/.kube/config
- az aks get-credentials --resource-group camelk-demo-resources  --name camelk-demo-aks

## Get token as follows
- kubectl config view 
    - token : <TOKEN>
    
## Various kubectl commands to see the details
- kubectl get all --all-namespaces
- kubectl get nodes
- kubectl get services
- kubectl get pods

## View login server
- az acr list --resource-group camelk-demo-resources --query "[].{acrLoginServer:loginServer}" --output table
    - OUTPUT : camelkdemocontainerregistry.azurecr.io

## List images from registry
- az acr repository list --name CamelkDemoContainerRegistry --output table

## View the kubernetes DASHBOARD
- az aks browse --resource-group camelk-demo-resources --name camelk-demo-aks

## Create namespace
- kubectl create namespace camel-basic
- kubectl config set-context --current --namespace=camel-basic

## Install Camel K
- kamel install --registry CamelkDemoContainerRegistry.azurecr.io --build-publish-strategy=Spectrum  --registry-auth-username CamelkDemoContainerRegistry --registry-auth-password <PWD> --force

## Run routes
- kamel run HelloWorld.java --dev
- kubectl get integrations
- kamel run HelloWorld.java
- kamel log HelloWorld
- kamel delete HelloWorld

## How to pass property file in kamel
- kamel run Routing.java --property-file routing.properties --dev

# Troubleshoot: FIX Empty pod/service issue
- kubectl delete clusterrolebinding kubernetes-dashboard
- kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard --user=clusterUser
