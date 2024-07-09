param containerAppsEnvName string
param location string
param registryName string

resource cappsEnv 'Microsoft.App/managedEnvironments@2022-01-01-preview' existing = {
  name: containerAppsEnvName
}

resource registry 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' existing = {
  name: registryName
}

resource bootstrapper 'Microsoft.App/containerApps@2022-03-01' = {
  name: 'bootstrapper'
  location: location
  properties: {
    managedEnvironmentId: cappsEnv.id
    template: {
      containers: [
        {
          name: 'bootstrapper'
          image: '${registry.properties.loginServer}/reddog/bootstrapper:latest'
          env: [
            {
              name: 'reddog-sql'
              secretRef: 'reddog-sql'
            }
          ]
        }
      ]
      scale: {
        minReplicas: 1
      }
    }
    configuration: {
      dapr: {
        enabled: true
        appId: 'bootstrapper'
        appProtocol: 'http'
      }
      registries: [
        {
          server: registry.properties.loginServer
          username: registry.listCredentials().username
          passwordSecretRef: 'registry'
        }
      ]
    }
  }
}
