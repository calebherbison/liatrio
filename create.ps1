
param (
  $subscriptionId = 'b9912d49-b7d7-4a55-b361-1613c829f4a2',
  $environmentName = 'lab-2',
  $location = 'centralus',
  $appName = 'api',
  $appFlavor = 'lab',
  $namespace = 'liatrio',
  $gitUrl = 'https://github.com/calebherbison/liatrio',
  $branch = 'main'
)

$clusterName = $environmentName
$resourceGroup = $environmentName

# set Azure subscription
az account set -s $subscriptionId

# create an Azure resource group
az group create `
  --name $resourceGroup `
  -l $location

# create kubernetes cluster
az aks create `
  -n $clusterName `
  -g $resourceGroup `
  --location $location `
  --node-vm-size Standard_DC2s_v3 `
  --node-count 1 `
  --generate-ssh-keys

# retrieve credentials for AKS cluster
az aks get-credentials `
  -n $clusterName `
  -g $resourceGroup 

# install Flux CD to the AKS cluster
flux install

kubectl create ns $namespace

# create sync job for git source
flux create source git api `
  --url=$gitUrl `
  --branch=$branch -n $namespace

# create sync job for kustomizations
flux create kustomization $appName `
  --source=GitRepository/$appName `
  --path="./kustomizations/overlays/$appFlavor" `
  --prune=true `
  --interval=5m `
  --wait=false `
  -n $namespace `
  --health-check-timeout=3m