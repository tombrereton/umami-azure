param name string
param location string
param lawName string

resource law 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: lawName
}

resource containerEnv 'Microsoft.App/managedEnvironments@2022-03-01' = {
  name: name
  location: location

  properties: {
    zoneRedundant: false
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: law.properties.customerId
        sharedKey: law.listKeys().primarySharedKey
      }
    }
  }
}

output id string = containerEnv.id
