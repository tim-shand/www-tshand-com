// Variables/Parameters
param location string
param appName string
param repoUrl string
param repoBranch string
param repoProvider string
param tags object
@secure()
param repoToken string
param skuName string
param skuTier string
param appLocation string
param apiLocation string
param appArtifactLocation string
param enterpriseGradeCdnStatus string

// Create Resource
resource staticWebApp 'Microsoft.Web/staticSites@2024-04-01' = {
  name: appName
  location: location
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    provider: repoProvider
    repositoryUrl: repoUrl
    repositoryToken: repoToken
    branch: repoBranch
    buildProperties: {
      skipGithubActionWorkflowGeneration: false
      appLocation: appLocation
      apiLocation: apiLocation
      appArtifactLocation: appArtifactLocation
    }
    enterpriseGradeCdnStatus: enterpriseGradeCdnStatus
    allowConfigFileUpdates: true
  }
  tags: tags
}
