# Terraform AI Search

This project implements a complete infrastructure for a Retrieval-Augmented Generation (RAG) solution using Azure AI Search, Azure AI Services, and other Azure resources. The infrastructure is managed as code using Terraform.

## File Structure

The project is organized into the following Terraform files, each responsible for a specific set of resources:

-   `main.tf`: Defines the main resource group where all other resources will be deployed.
-   `versions.tf`: Specifies the required versions of Terraform and the Azure providers. It also configures the Terraform state backend to store the state file remotely in Azure Storage.
-   `variables.tf`: Declares all input variables used in the Terraform configuration, such as location, environment, and AI model names.
-   `locals.tf`: Defines local variables, such as resource prefixes and common tags, to simplify and standardize resource naming and tagging.
-   `envs/dev.tfvars`: Environment-specific variables file for development. It contains the values for the variables defined in `variables.tf`.

### Application Resources

-   `ai-services.tf`: Provisions an Azure AI Services account, an Azure AI Foundry Hub, and an AI Foundry project. It also deploys the embedding and chat models required for the RAG solution.
-   `search.tf`: Creates the Azure AI Search service and configures the necessary RBAC roles for the indexer to access data in Azure Storage and use AI services for vectorization.
-   `storage.tf`: Creates an Azure Storage account to store the documents to be indexed and a blob container.
-   `functions.tf`: Deploys an Azure Function App that can be used for data ingestion, processing, or orchestrating the RAG flow. It includes the configuration of the managed identity and RBAC roles to access other services.
-   `acr.tf`: Creates an Azure Container Registry to store custom container images if needed.
-   `keyvault.tf`: Provisions an Azure Key Vault for secure management of secrets, keys, and certificates.
-   `monitoring.tf`: Configures application monitoring by creating a Log Analytics workspace and an Application Insights instance.
-   `outputs.tf`: Defines the outputs of the Terraform deployment, such as service endpoints, resource names, and access keys (although the use of managed identities is recommended).

## How to Run

### Prerequisites

-   [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) installed.
-   [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and configured with a logged-in session (`az login`).
-   Adequate permissions in an Azure subscription to create the resources.
-   A configured Terraform backend (as defined in `versions.tf`). You will need to create the storage account and container for the Terraform state manually.

### Initialization

Navigate to the `infrastructure` directory and run the following command to initialize Terraform. This will download the necessary providers and configure the backend.

```bash
terraform init
```

### Plan

Generate an execution plan to preview the resources that will be created. Use the appropriate `.tfvars` file for your environment.

```bash
terraform plan -out=tfplan -var-file="envs\dev.tfvars"
```

### Apply

Apply the plan to create the infrastructure in Azure. The command will use the plan file generated in the previous step.

```bash
terraform apply -auto-approve tfplan
```

### Destroy

To delete all resources created by this Terraform configuration, run the following command:

```bash
terraform destroy -var-file="envs\dev.tfvars"
```
