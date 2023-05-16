# Liatrio Cloud Native Exercise

## Getting Started  

### Prerequisites  

- Microsoft Azure account
  
- Microsoft Azure subscription
-- https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/initial-subscriptions

- PowerShell
-- https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.3

- kubectl
-- https://kubernetes.io/docs/tasks/tools/

- kustomize
-- https://kubectl.docs.kubernetes.io/installation/kustomize/

- Az CLI
-- https://learn.microsoft.com/en-us/cli/azure/install-azure-cli

- FluxCD CLI
-- https://fluxcd.io/flux/cmd/


### Initialize

1. Initialize cloud resources and deploy an application
   
    ```
    ./create.ps1 `
        -SubscriptionId 'b9912d49-b7d7-4a55-b361-1613c829f4a2' `
        -EnvironmentName 'lab-1'
    ```

### Notes

- Uses calebherbisonliatrio.azurecr.io Azure container registry with anonymous pulls enabled 
- Uses GitHub Actions to build, tag, and push application's Docker image to Azure container registry
- Uses Kustomizations to declare Kubernetes manifests
- Uses FluxCD to monitor main branch of repository for manifest updates and automatically deploys them to the cluster
- Uses AZ CLI to create Azure resources (similar to using Bicep but doesn't keep track of state like Terraform)
- Any changes to the main branch will be deployed to the lab-0 environment (in my personal subscription; if this fails at the least a Docker image will be pushed)

### Potential improvements

- Authn and authz on the API
- Private cluster not accessible from the internet
- Pod Identity to allow pods to request an Azure Active Token and use it to access Azure resources or other APIs and services
- Secrets management using Azure key vault, Hashicorp vault, or another tool
- Ingress management using nginx or other ingress controller
- TLS certificates enrollment and renewal using Let's Encrypt or other ACME server
- Well-defined git strategy i.e. GitHub Flow, Gitflow, or trunk-based development
- Observability with Prometheus/Grafana or other monitoring tools
- Better defined deployment strategies centered around GitOps
- Health checks and alerting
- Create Docker image with prequisite tools