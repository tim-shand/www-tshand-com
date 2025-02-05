// Scoped to subscription.
targetScope = 'subscription'

// Variables/Parameters
// -- Azure Static Web Apps restricted to specific regions.
// -- westus2 has the lowest latency (https://www.azurespeed.com/Azure/Latency). 
@allowed(['centralus', 'eastus2', 'eastasia', 'westeurope', 'westus2'])
param location string
param tags object
param global_env string // Using a universial environment type (prd/dev/stg).
param global_prefix string // Using a universial variable name for all resources.

// Static Web App: Parameters
param repoProvider string
@secure()
param repoToken string
param repoUrl string
param repoBranch string
param skuName string
param skuTier string
param appLocation string
param apiLocation string
param appArtifactLocation string
param enterpriseGradeCdnStatus string

//----------------------------------------------//
// Create Resource Group
@description('Create a resource group for project.')
resource rg 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: '${global_prefix}-${global_env}-rg'
  location: location
  tags: tags
}

// Create Static Web App using module file.
module swa 'static-web-app.bicep' = {
  //scope: resourceGroup(rg.name)
  scope: rg
  name: '${global_prefix}-${global_env}-swa'
  params: {
    location: rg.location
    skuName: skuName
    skuTier: skuTier
    appName: '${global_prefix}-${global_env}-swa'
    repoBranch: repoBranch
    repoProvider: repoProvider
    repoUrl: repoUrl
    repoToken: repoToken
    apiLocation: apiLocation
    appArtifactLocation: appArtifactLocation
    appLocation: appLocation
    enterpriseGradeCdnStatus: enterpriseGradeCdnStatus
    tags: tags
  }
}
