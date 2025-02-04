// Scoped to subscription.
targetScope = 'subscription'

// Variables/Parameters
// -- Azure Static Web Apps restricted to specific regions.
// -- westus2 has the lowest latency (https://www.azurespeed.com/Azure/Latency). 
@allowed(['centralus', 'eastus2', 'eastasia', 'westeurope', 'westus2'])
param location string
param rgName string
param tags object

// Static Web App: Parameters
param repoProvider string
@secure()
param repoToken string
param repoUrl string
param repoBranch string
param webAppName string
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
  name: rgName
  location: location
  tags: tags
}

module swa 'static-web-app.bicep' = {
  scope: resourceGroup(rg.name)
  name: webAppName
  params: {
    location: location
    skuName: skuName
    skuTier: skuTier
    appName: webAppName
    repoBranch: repoBranch
    repoProvider: repoProvider
    repoUrl: repoUrl
    repoToken: repoToken
    apiLocation: apiLocation
    appArtifactLocation: appArtifactLocation
    appLocation: appLocation
    enterpriseGradeCdnStatus: enterpriseGradeCdnStatus
  }
}
