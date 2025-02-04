using 'main.bicep'

// General
param rgName = 'tjs-wwwtshandcom-prd-rg'
param location = 'westus2'
param tags = {
  CreatedBy: 'bicep'
  Environment: 'prd'
  Project: 'www-tshand-com'
}
// Web App
param repoProvider = 'Github'
param repoToken = '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'
param repoUrl = 'https://github.com/tim-shand/www-tshand-com.git'
param repoBranch = 'main'
param webAppName = 'tjs-wwwtshandcom-prd-swa'
param skuName = 'free'
param skuTier = 'free'
param appLocation = '/src'
param apiLocation = ''
param appArtifactLocation = 'public'
param enterpriseGradeCdnStatus= 'disabled'
