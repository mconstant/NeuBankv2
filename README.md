# Instructions
1. Fork this repo
2. In Github get a Personal Account Token for the forked repo that allows changing secrets for it.
    1. Github Account Settings > Developer Settings > Personal Access Tokens > Fine-grained Tokens > Generate New Token
        1. Only select the repo you want actions set up in.
        2. Token name can be `neubank-example-terraform-actions`
        3. In `Repo Permissions` choose `Secrets` `Read and Write`
2. Install `terraform` if you haven't
4. Do the following to bootstrap actions and storing Terraform State in Azure
    ```shell
    $ echo 'export PAT_TOKEN_VALUE=<your_pat_token>' >> .env
    $ source .env 
    $ make bootstrap
    ```
    3. Enter `your_github_username` when prompted for `var.github_user_name`
    4. Grab more tea while it makes a container for remote tfstate in Azure and sets the secrets in your Github repo so the actions in this repo can `terraform plan` etc. You will still need to do the next step to initalize workspaces before this works.
    5. When done initialize all the workspaces for our environments by running the `Add Terraform Workspaces` Github Action
    

-----

# Senior Cloud Infrastructure Consultant
## Take Home Exercise

The NeuBank Mortgage is an online mortgage company that offers home loans for new home buyers. As part of their platform modernization effort, they recently upgraded their mortgage calculator to provide a better digital experience for customers.

The application was implemented using a three-tier architecture: presentation, application, and data. 
As a cloud infrastructure architect, you’ve been asked to provision the required Azure services using Infrastructure as Code (IaC) tools to deploy the latest version of the mortgage calculator in their Dev environment. Below are the requirements:

•	Deploy the application to the East US region.

•	Deploy resources to a resource group named dev-rgp-cis-neubank-use-001.

•	Create an App Service to deploy the frontend part of the application.

•	Create an App Service to deploy the backend API part of the application.

•	Create an Azure SQL database to store calculations from the mortgage calculator.

•	Set up Blob Storage for media and related content.

•	Configure App Insights to record telemetry data from the application.

•	The application and data tiers should only be accessible inside a virtual network. They should not be exposed to the public internet and should only be accessible by the presentation tier.

•	All Azure resources should have the following tags:

o	Environment = Dev

o	Owner = first.last@company.com

o	Project = Mortgage Calculator

Deliverables

•	Create IaC templates for the above requirements, preferably using Azure Bicep or Terraform.

•	The IaC templates should support multi environment deployments (Dev, Test, Prod).

•	Publish IaC templates to a public GitHub repository with a regular commit history.

•	Demonstrate IaC template execution using CI/CD, preferably using GitHub Actions or Azure DevOps Pipelines.

•	Create an architecture diagram for the above deployed infrastructure.

FAQ

Do I need an Azure subscription?

Yes, you need an Azure subscription to provision and test the infrastructure services using IaC. We recommend creating a free Azure account. 

A free Azure account gives you a $200 credit to spend in the first 30 days. In addition, you get free monthly amounts of two groups of services: popular services, which are free for 12 months, and more than 55 other services that are always free. For more details see https://azure.microsoft.com/en-us/pricing/free-services.

Do I need to delete my resources?

Yes, please delete the provisioned Azure resources after testing to avoid unnecessary charges.
What type of Azure SKUs should I use for provisioning resources?

Since this is just a coding exercise, we recommend using the basic tier SKUs.

