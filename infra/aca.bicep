@secure()
param mySqlServerPassword string
param mySqlServerName string
param databaseName string
param location string
param name string
param containerAppEnvironmentId string

@secure()
param hashSalt string


// variables
var secrets = [
  {
    name: 'database-url'
    value: 'mysql://umami:${mySqlServerPassword}@${mySqlServerName}.mysql.database.azure.com:3306/${databaseName}?sslaccept=strict'
  }
  {
    name: 'hash-salt'
    value: hashSalt
  }
]

var envVars = [
  {
    name: 'DATABASE_URL'
    secretRef: 'database-url'
  }
  {
    name: 'HASH_SALT'
    secretRef: 'hash-salt'
  }
  {
    name: 'DATABASE_TYPE'
    value: 'mysql'
  }
]

// resource
resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: name
  location: location
  properties: {
    managedEnvironmentId: containerAppEnvironmentId
    configuration: {
      ingress: {
        external: true
        targetPort: 3000
      }
      secrets: secrets
    }
    template: {
      containers: [
        {
          image: 'ghcr.io/umami-software/umami:mysql-latest'
          name: 'umamia-app'
          env: envVars
        }
      ]
      scale: {
        minReplicas: 0
      }
    }
  }
}


// add container app ip to mysql server firewall
resource mysqlServer 'Microsoft.DBforMySQL/flexibleServers@2021-05-01' existing = {
  name: mySqlServerName
}

resource containerAppFirewallRule 'Microsoft.DBforMySQL/flexibleServers/firewallRules@2021-05-01' = {
  name: 'umami-app'
  parent: mysqlServer
  properties: {
    endIpAddress: containerApp.properties.outboundIpAddresses[0]
    startIpAddress: containerApp.properties.outboundIpAddresses[0]
  }
}

output fqdn string = containerApp.properties.configuration.ingress.fqdn
