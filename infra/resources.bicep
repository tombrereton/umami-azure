// parameters
@allowed([
  'test'
  'pdn'
])
param env string

param appName string

param location string = resourceGroup().location

@secure()
param databasePassword string

@secure()
param hashSalt string

// resource names
var mySqlServerName = 'mysql-${appName}-${env}'
var lawName = 'law-${appName}-${env}'
var envName = 'env-${appName}-${env}'
var acaName = 'aca-${appName}-${env}'

// resources
module datastore 'mysql.bicep' = {
  name: 'datastore'
  params: {
    mySqlServerPassword: databasePassword
    mySqlServerName: mySqlServerName
    location: location
    databaseName: appName
  }
}

module logAnalyticsWorkspace 'law.bicep' = {
  name: 'log-analytics-workspace'
  params: {
    location: location
    name: lawName
  }
}

module containerAppEnvironment 'env.bicep' = {
  dependsOn: [ datastore, logAnalyticsWorkspace ]
  name: 'container-app-environment'
  params: {
    name: envName
    location: location
    lawName: lawName
  }
}

module containerApp 'aca.bicep' = {
  dependsOn: [ datastore, containerAppEnvironment ]
  name: 'aca-umami'
  params: {
    name: acaName
    location: location
    containerAppEnvironmentId: containerAppEnvironment.outputs.id
    mySqlServerName: mySqlServerName
    mySqlServerPassword: databasePassword
    databaseName: appName
    hashSalt: hashSalt
  }
}
