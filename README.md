# Login to Azure
- az login 

# Create resource group using CLI
- az group create --name camel-rg-poc --location eastus

#Create azure container registry using "acr create"
- az acr create --resource-group camel-rg-poc  --name camelpocregistry --sku Basic

# Login to azure portal and enable access key to ACR, it will generate user name and password
    - username: camelpocregistry
    - password: <PWD>
    
# Login to Azure Container Registry
- az acr login --name camelpocregistry --resource-group camel-rg-poc --username camelpocregistry --password <PWD>

# Create an AKS cluster with ACR integration
- az aks create -n aks-cluster-dev -g camel-rg-poc --generate-ssh-keys --attach-acr camelpocregistry

# Update it later if needed
- az aks update -n aks-cluster-dev -g camel-rg-poc --attach-acr camelpocregistry

# Get credential
- az aks get-credentials --resource-group camel-rg-poc  --name aks-cluster-dev

# Various kubectl commands to see the details
- kubectl get all --all-namespaces
- kubectl get nodes
- kubectl get services
- kubectl get pods

# View login server
- az acr list --resource-group camel-rg-poc --query "[].{acrLoginServer:loginServer}" --output table
    - OUTPUT : camelpocregistry.azurecr.io

#List images from registry
- az acr repository list --name camelpocregistry --output table

# View the kubernetes DASHBOARD
- az aks browse --resource-group camel-rg-poc --name aks-cluster-dev

# Get token as follows
- kubectl config view 
    - token : <TOKEN>

# Create namespace
- kubectl create namespace camel-basic
- kubectl config set-context --current --namespace=camel-basic
- kubectl get integrationplatform

# Install Camel K
- kamel install --registry camelpocregistry.azurecr.io --build-publish-strategy=Spectrum  --registry-auth-username camelpocregistry --registry-auth-password <PWD> --force

# Run routes
- kamel run Basic.java --dev
- kubectl get integrations
- kamel run Basic.java
- kamel log basic
- kamel delete basic

- kamel run Routing.java --property-file routing.properties --dev

# Troubleshoot: FIX Empty pod/service issue
- kubectl delete clusterrolebinding kubernetes-dashboard
- kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard --user=clusterUser

# May be
- kamel install --registry docker.io --organization sunilkeyal --registry-auth-username sunilkeyal --registry-auth-password ktM27519!
