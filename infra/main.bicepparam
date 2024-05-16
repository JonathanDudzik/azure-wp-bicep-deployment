using './main.bicep'

// name, location, and uniqueSuffix are passed through the 
// CLI command (given precedence) and are here for reference only
param name = 'Development'
param location = 'east'
param uniqueSuffix = 'SUFFIX-UNIQUE_CODE'

param availabilityZone = '1'
param currentTimeDate = ''
param containerAppsEnvName = 'cae-${uniqueSuffix}'
param haEnabled = 'Disabled'
param logAnalyticsWorkspaceName = 'log-${uniqueSuffix}'
param appInsightsName = 'appi-${uniqueSuffix}'
param standbyAvailabilityZone = '2'
param storageAccountName = 'st${replace(uniqueSuffix, '-', '')}'
param blobContainerName = 'receipts'
param registryName = 'acr${replace(uniqueSuffix, '-', '')}'
param resourceTags = {
  environment: name
  owner: 'Jonathan Dudzik'
  createdAt: currentTimeDate
}
param sqlServerName = 'mySql-${uniqueSuffix}'
param sqlDatabaseName = 'wp_${uniqueSuffix}'
param sqlAdminLogin = 'jonathan.d.wesley@gmail.com'
param sqlServerEdition = 'Burstable'
param sqlSkuName = 'Standard_B1s'
param sqlVersion = '8.0.21'
