targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('The name for the project. Use lowercase and delimited by dashes e.g. test-project')
param appName string

@allowed([
  'test'
  'pdn'
])
@description('Environment of the resources to be created.')
param env string

@minLength(1)
@description('Location of the resources to be created.')
param location string = 'Australia East'

@description('Password for login into MySQL Server.')
@secure()
param databasePassword string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${appName}-${env}'
  location: location
}

module resources 'resources.bicep' = {
  scope: rg
  name: 'resources'
  params: {
    appName: toLower(appName)
    location: location
    env: env
    databasePassword: databasePassword
  }
}

output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
