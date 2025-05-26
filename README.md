# Personal Portfolio/Blog Website (tshand.com)

Personal blog website to document my IT journey, progress and lessons learned.  
This is a static site deployed using Hugo, Azure Static Web Apps and Github Actions.  
Using this style of site generation allows me to create markdown files and push them to this repo.  
Doing so will trigger a Github Actions workflow to build and deploy the site into Azure.  

## Infrastructure and Tools

- **Azure:**
  - Existing knowledge and experience with this cloud service provider.
  - Free tier offering for Static Web Apps.
  - Built-in integration options for Github.
- **Bicep**
  - Infra-as-Code for Azure resource provisioning.
  - Domain-specific language (DSL) for Azure, with excellent support for new features.
  - No need to maintain a state file (like Terraform) as it's built into Azure.
- **Hugo:**
  - Static site generator, uses Markdown files for blog posts.
  - Free, simple to setup and run.
- **Github Actions:**
  - New code commits trigger Hugo and Azure static site rebuild.
  - Easily integrated into Bicep module for IaC deployment.

## Hugo

### Installation & Setup

Review the [official vendor documentation](https://gohugo.io/installation/) for more information.  

1. Open a terminal window and execute the below command:  
**Windows:** `winget install Hugo.Hugo.Extended`  
**Ubuntu/Debian:** `sudo apt install hugo`  
**Fedora/CentOS:** `dnf install hugo`  

2. Accept the agreement terms (Y) and press enter.  
3. After installation, the PATH environment variable will have been modified.  
4. To start using Hugo, close and re-open the terminal window (due to PATH update).  
5. Verify that Hugo is installed by executing the below command:  
`hugo version`
6. Execute the below commands to configure a new Hugo site locally and import a chosen theme:  

```bash
hugo new site my_site
cd my_site
git init
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke"
```

7. Add line to top of 'hugo.yaml. file:

```yaml
theme: hugo-theme-stack-master
```

8. To run the server locally (for development), use the `-c` parameter to specify the source directory. 

`hugo server -s ./src`  

## Bicep

- Using a main Bicep file to provision the initial Resource Group, and a module file for the Static Web App.  
- As we are deploying a resource group to contain the project, we need to deploy it at the "subscription" scope.  
- To deploy to a subscription, use the `az deployment sub create` command:

```bash
# Syntax:
az deployment sub create --location <location> --template-file <path-to-bicep> --parameters <path-to-params>

# Example:
az deployment sub create --location westus2 --template-file .\infra\main.bicep --parameters .\infra\main.bicepparam

```
