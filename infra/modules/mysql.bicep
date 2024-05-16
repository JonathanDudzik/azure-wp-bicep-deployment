// Can / Should this database server have private access only within a vnet?
param availabilityZone string
param haEnabled string
param location string
param resourceTags object
param standbyAvailabilityZone string
param sqlAdminLogin string
param sqlDatabaseName string
param sqlServerEdition string
param sqlServerName string
param sqlSkuName string
param sqlVersion string
@secure()
param sqlAdminLoginPassword string

resource sqlServer 'Microsoft.DBforMySQL/flexibleServers@2021-12-01-preview' = {
  name: sqlServerName
  location: location
  tags: resourceTags
  sku: {
    name: sqlSkuName
    tier: sqlServerEdition
  }
  properties: {
    version: sqlVersion
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlAdminLoginPassword
    availabilityZone: availabilityZone
    highAvailability: {
      mode: haEnabled
      standbyAvailabilityZone: standbyAvailabilityZone
    }
    // all the storage setting are minimuns
    storage: {
      storageSizeGB: 20
      iops: 360
      autoGrow: 'Disabled'
    }
    backup: {
      backupRetentionDays: 4
      geoRedundantBackup: 'Disabled'
    }
  }
}

resource sqlFirewallRules 'Microsoft.Sql/servers/firewallRules@2021-05-01-preview' = {
  name: 'sqlServerName/rule'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}


resource database 'Microsoft.DBforMySQL/flexibleServers/databases@2021-12-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  properties: {
    charset: 'utf8'
    collation: 'utf8_general_ci'
  }
}
