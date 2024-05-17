targetScope = 'subscription'

@description('This value will be different for each run. Format: 20190305T175318Z')
param currentTimeDate string = utcNow()
@description('should be passed in CLI command: Azure location used for all resources.')
param location string
@minLength(1)
@maxLength(20)
@description('should be passed in CLI command: environment name used to generate a unique hash used in all resources.')
param name string
@description('should be passed in CLI command: used for resource group and registry name.')
param uniqueSuffix string
@description('The value for a secure parameter is not logged or saved to the deployment history')
@secure()
param sqlAdminLoginPassword string = take(newGuid(), 16)

// the below parameters are set in the main.bicepparam file
param appInsightsName string
@description('The availability zone information for the server. (If you do not have a preference, leave blank.)')
param availabilityZone string
param blobContainerName string
param containerAppsEnvName string
@description('High availability mode for a server: Disabled, SameZone, or ZoneRedundant.')
@allowed([
  'Disabled'
  'SameZone'
  'ZoneRedundant'
])
param haEnabled string
param logAnalyticsWorkspaceName string
param registryName string
param resourceTags object = {
  createdAt: currentTimeDate
}
@description('The availability zone of the standby server.')
param standbyAvailabilityZone string
param storageAccountName string
param sqlServerName string
param sqlDatabaseName string
param sqlAdminLogin string
param sqlSkuName string
@description('This may need to be GeneralPurpose once the protfolio is live')
@allowed([
  'Burstable'
  'GeneralPurpose'
  'MemoryOptimized'
])
param sqlServerEdition string
@allowed([
  '5.7'
  '8.0.21'
])
param sqlVersion string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${name}-${uniqueSuffix}'
  location: location
  tags: resourceTags
}

module insightsModule 'modules/insights.bicep' = {
  name: '${deployment().name}--appinsights'
  scope: resourceGroup
  params: {
    appInsightsName: appInsightsName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    location: location
  }
}

module containerAppsEnvModule 'modules/aca.bicep' = {
  name: '${deployment().name}--containerAppsEnv'
  scope: resourceGroup
  dependsOn: [
    insightsModule
  ]
  params: {
    location: location
    containerAppsEnvName: containerAppsEnvName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    appInsightsName: appInsightsName
  }
}

module storageModule 'modules/storage.bicep' = {
  name: '${deployment().name}--storage'
  scope: resourceGroup
  params: {
    storageAccountName: storageAccountName
    blobContainerName: blobContainerName
    location: location
  }
}

module sqlServerModule 'modules/mysql.bicep' = {
  name: '${deployment().name}--sqlserver'
  scope: resourceGroup
  params: {
    sqlServerName: sqlServerName
    sqlDatabaseName: sqlDatabaseName
    sqlAdminLogin: sqlAdminLogin
    sqlAdminLoginPassword: sqlAdminLoginPassword
    sqlServerEdition: sqlServerEdition
    location: location
    resourceTags: resourceTags
    sqlSkuName: sqlSkuName
    sqlVersion: sqlVersion
    availabilityZone: availabilityZone
    haEnabled: haEnabled
    standbyAvailabilityZone: standbyAvailabilityZone
  }
}

module registryModule 'modules/acr.bicep' = {
  name: '${deployment().name}--docker-registry'
  scope: resourceGroup
  params: {
    registryName: registryName
    location: location
  }
}

module portolioModule 'modules/containerApps/portfolio.bicep' = {
  name: '${deployment().name}--order-service'
  scope: resourceGroup
  dependsOn: [
    containerAppsEnvModule
  ]
  params: {
    location: location
    containerAppsEnvName: containerAppsEnvName
    registryName: registryName
    sqlAdminLogin: sqlAdminLogin
    sqlAdminLoginPassword: sqlAdminLoginPassword
    sqlDatabaseName: sqlDatabaseName
    sqlServerName: sqlServerName
  }
}

output AZURE_CONTAINER_REGISTRY_ENDPOINT string = registryModule.outputs.loginServer
