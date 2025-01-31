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
2. Accept the source agreement terms (Y) and press enter.  
3. After installation, the PATH environment variable will have been modified.  
4. To begin using Hugo, close and re-open the terminal window.  
5. Confirm Hugo is install by executing the below command:  
`hugo version`

### Initial Setup

Execute the below commands to configure a new Hugo site locally and import a chosen theme:  

```text
hugo new site my_site
cd my_site
git init

git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke

echo "theme = 'ananke'" >> hugo.toml
hugo server
```

## Bicep

As we are deploying a resource group to contain the project, we need to deploy at the "subscription" scope.  
To deploy to a subscription, use az deployment sub create:

```azurecli
az deployment sub create --location <location> --template-file <path-to-bicep>
```
