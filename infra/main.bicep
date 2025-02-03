//Scoped to subscription.
targetScope = 'subscription'

// Variables/Paramters

// Azure Static Apps restricted to specific regions.
// westus2 has the lowest latency (https://www.azurespeed.com/Azure/Latency). 
@allowed([ 'centralus', 'eastus2', 'eastasia', 'westeurope', 'westus2' ])
param location string = 'westus2'

// Resources
@description('Create a resource group')
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: 'tjs-prd-tshandcom-rg'
  location: location
}

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

// Outputs
@description('Output the default hostname')
output endpoint string = swa.outputs.defaultHostname

@description('Output the static web app name')
output staticWebAppName string = swa.outputs.name
