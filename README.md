# Personal Portfolio/Blog Website (tshand.com)

Personal blog website to document my IT journey, progress and lessons learned.  
This is a static site deployed using Hugo and Azure Static Web Apps.  

This is my chosen deployment method due to the following:

- Azure: Familiar with platform already.
- IaC: Bicep for resource provisioning (Azure native).
- Hugo: Quick and easy to setup and run.
  - Uses Markdown for blog posts.
  - Can host in Azure Static Web Apps for free.

## Hugo

### Installation

#### Windows

1. Open a terminal window and execute the below command:  
`winget install Hugo.Hugo.Extended`  
2. Accept the agreement terms (Y) and press enter.  
3. After installation, the PATH environment variable will have been modified.  
4. To start using Hugo, close and re-open the terminal window (due to PATH update).  
5. Verify that Hugo is installed by executing the below command:  
`hugo version`

### Initial Setup

Execute the below commands to configure a new Hugo site locally and import a chosen theme:  

```text
hugo new site my_site
cd my_site
git init

git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke

echo "theme = 'ananke'" >> hugo.toml
```

Run the server, using the `-c` parameter to specify the source directory.  
`hugo server -s ./src`  

## Bicep

As we are deploying a resource group to contain the project, we need to deploy at the "subscription" scope.  
To deploy to a subscription, use az deployment sub create:

```azurecli
# Syntax:
az deployment sub create --location <location> --template-file <path-to-bicep> --parameters <path-to-params>

# Example:
az deployment sub create --location westus2 --template-file .\infra\main.bicep --parameters .\infra\main.bicepparam

```
