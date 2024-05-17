using './blog.bicep'

// name, location, uniqueSuffix, and registry are passed through the 
// CLI command (given precedence) and are here for reference only
param name = 'Development'
param location = 'east'
param uniqueSuffix = ''
param registryName = ''


param currentTimeDate = ''
param containerAppsEnvName = 'cae-${uniqueSuffix}'
param resourceTags = {
  environment: name
  owner: 'Jonathan Dudzik'
  createdAt: currentTimeDate
}
param sqlServerName = 'mySql-${uniqueSuffix}'
param sqlDatabaseName = 'wp_${uniqueSuffix}'
param sqlAdminLogin = 'jonathan.d.wesley@gmail.com'
