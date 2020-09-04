# Download terraform binary
- location: https://www.terraform.io/downloads.html
- put the downloaded binary in path
- $ terraform --version

# Terraform in docker
- $ cd terraform-docker
- $ terraform init
- $ terraform plan (to view what will happen whey applied)
- $ terraform apply (apply the change)
    - Verify that docker container has been created by visiting http://localhost:8000 works
- terraform destroy (destroy whatever had been applied previously)

# Build Azure infrastructure with AKS for Camel-K using terraform
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

# Check and configure Kubernetes install
- $ kubectl config view 
    - token : <TOKEN>>
- $  az aks browse --resource-group example-resources --name example-aks

# Login to azure portal and enable access key to ACR, it will generate username and password
    username: exampleContainerRegistry1
    password: <PWD>
# Login to Azure Container Registry
- az acr login --name exampleContainerRegistry1 --resource-group example-resources --username exampleContainerRegistry1 --password <PWD>

# Update ask with newly created ACR (Figure this out to put in main.tf)
- $ az aks update -n example-aks -g example-resources --attach-acr exampleContainerRegistry1

# Get credential
- az aks get-credentials --resource-group example-resources  --name example-aks

# Create namespace
- kubectl create namespace camel-basic
- kubectl config set-context --current --namespace=camel-basic
- kubectl get integrationplatform

# Install Camel K in kubernetes
- kamel install --registry exampleContainerRegistry1.azurecr.io --build-publish-strategy=Spectrum  --registry-auth-username exampleContainerRegistry1 --registry-auth-password <PWD> --force

# Run camel k application
- kamel run helloworld.groovy --dev
- kubectl get integrations
- kamel run helloworld.groovy
- kamel log basic
- kamel delete basic

# Fix if there is nothing inside aks dashboard
- kubectl delete clusterrolebinding kubernetes-dashboard
- kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard --user=clusterUser
