// Static Web App
resource symbolicname 'Microsoft.Web/staticSites@2024-04-01' = {
  identity: {
    type: 'string'
  }
  kind: 'string'
  location: location
  name: 'string'
  properties: {
    allowConfigFileUpdates: bool
    branch: 'main'
    buildProperties: {
      appArtifactLocation: 'string'
      appBuildCommand: 'string'
      appLocation: './src'
      githubActionSecretNameOverride: 'string'
      outputLocation: 'string'
      skipGithubActionWorkflowGeneration: bool
    }
    enterpriseGradeCdnStatus: 'string'
    provider: 'string'
    publicNetworkAccess: 'string'
    repositoryToken: 'string'
    repositoryUrl: 'https://github.com/tim-shand/www-tshand-com'
    stagingEnvironmentPolicy: 'string'
    templateProperties: {
      description: 'string'
      isPrivate: bool
      owner: 'string'
      repositoryName: 'string'
      templateRepositoryUrl: 'string'
    }
  }
  sku: {
    name: 'free'
    size: 'free'
  }
  tags: {
    project: 'www-tshand-com'
    environment: 'prd'
  }
}
