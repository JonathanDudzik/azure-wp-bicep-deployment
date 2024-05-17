targetScope = 'subscription'

@description('This value will be different for each run. Format: 20190305T175318Z')
param currentTimeDate string = utcNow()
@description('should be passed in CLI command: Azure location used for all resources.')
param location string
@minLength(1)
@maxLength(20)
@description('should be passed in CLI command: environment name used to generate a unique hash used in all resources.')
param name string
@description('should be passed in CLI command: used for naming of various resources.')
param uniqueSuffix string
@description('should be passed in CLI command: used for identifying the ACR name.')
@secure()
param registryName string

@description('The value for a secure parameter is not logged or saved to the deployment history')
@secure()
param sqlAdminLoginPassword string = take(newGuid(), 16)

// the below parameters are set in the blog.bicepparam file
param containerAppsEnvName string
param resourceTags object = {
  createdAt: currentTimeDate
}
@description('The availability zone of the standby server.')

param sqlServerName string
param sqlDatabaseName string
param sqlAdminLogin string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${name}-${uniqueSuffix}'
  location: location
  tags: resourceTags
}

module containerAppsEnvModule 'modules/aca.bicep' = {
  name: '${deployment().name}--containerAppsEnv'
  scope: resourceGroup
  params: {
    location: location
    containerAppsEnvName: containerAppsEnvName
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

module blogModule 'modules/containerApps/blog.bicep' = {
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
