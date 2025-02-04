
// Resource Group 
// Resource (Microsoft.Resources/resourceGroups) has to be deployed at the subscription scope. 
// Since the scope of the bicep file is subscription as well, we can deploy resource group in the main file.

// Storage account resource has to be deployed at the resourceGroup scope. 
// Therefore, we need to use modules to deploy it at a scope different from the main file.

// Scoped to subscription.
targetScope = 'subscription'

// Variables/Parameters

// Azure Static Apps restricted to specific regions.
// westus2 has the lowest latency (https://www.azurespeed.com/Azure/Latency). 
@allowed([ 'centralus', 'eastus2', 'eastasia', 'westeurope', 'westus2' ])
param location string = 'westus2'

// Create Resource Group
@description('Create a resource group')
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: 'tjs-prd-tshandcom-rg'
  location: location
}

// Create Static Web App
@description('Create a static web app')
module swa 'br/public:avm/res/web/static-site:0.3.0' = {
  name: 'client'
  scope: rg
  params: {
    name: 'tjs-prd-tshandcom-swa'
    location: location
    sku: 'Free'
  }
}

module swa2 'Microsoft.Web/staticSites@2024-04-01' = {
}

// Outputs
@description('Output the default hostname')
output endpoint string = swa.outputs.defaultHostname

@description('Output the static web app name')
output staticWebAppName string = swa.outputs.name
