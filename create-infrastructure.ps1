
# install kubectl
# install kustomize
# install az cli
# install flux cli

param (
  $SubscriptionId = 'b9912d49-b7d7-4a55-b361-1613c829f4a2'
  $clusterName = 'lab-0'
  $resourceGroup = 'lab-0'
  $location = 'centralus'
  $acrName = "calebherbisonliatrio"
)

$vnetName="$resourceGroup-vnet-cus"

# set Azure subscription
az account set -s $SubscriptionId

# create an Azure resource group
az group create --name $resourceGroup -l $location

# create vnet
az network vnet create -n $vnetName -g $resourceGroup
az network vnet subnet create -n 'default' -g $resourceGroup --vnet-name $vnetName --address-prefixes "10.0.0.0/16"

az acr create -n $acrName -g $resourceGroup --sku Standard

# create kubernetes cluster
az aks create -n $clusterName -g $resourceGroup --location $location `
  --node-vm-size Standard_DC1s_v3 `
  --node-count 1 `
  --generate-ssh-keys `
  --attach-acr "/subscriptions/$SubscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.ContainerRegistry/registries/$acrName"

az aks get-credentials -n $clusterName -g $resourceGroup 

kubectl create ns liatrio

flux install
flux create source git api --url=https://github.com/calebherbison/liatrio --branch=main -n liatrio

# create lab kustomization
flux create kustomization api `
    --source=GitRepository/api `
    --path="./kustomizations/overlays/lab" `
    --prune=true `
    --interval=60m `
    --wait=false `
    --health-check-timeout=3m

flux reconcile source git api -n liatrio
flux reconcile kustomization api --with-source -n liatrio

kustomize build kustomizations/overylays/lab

