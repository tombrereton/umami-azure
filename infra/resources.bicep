param appName string
param location string = resourceGroup().location

@secure()
param databasePassword string

@allowed([
  'test'
  'pdn'
])
param env string

var mySqlServerName = 'mysql-${appName}-${env}'
var acrName = 'acr${appName}${env}'

module datastore 'mysql.bicep' = {
  name: 'datastore'
  params: {
    databasePassword: databasePassword
    mySqlServerName: mySqlServerName
    location: location
  }
}

module acr 'acr.bicep' = {
  name: 'acr'
  params: {
    acrName: acrName
    acrSku: 'Basic'
    location: location
  }
}
