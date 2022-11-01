param mySqlServerName string
param location string = resourceGroup().location

@secure()
param databasePassword string


resource mysqlServer 'Microsoft.DBforMySQL/flexibleServers@2021-05-01' = {
  name: mySqlServerName
  location: location
  sku: {
    name: 'Standard_B1s'
    tier: 'Burstable'
  }
  properties: {
    administratorLogin: 'umami'
    administratorLoginPassword: databasePassword
    storage: {
      storageSizeGB: 20
      iops: 360
      autoGrow: 'Enabled'
    }
    backup: {
      backupRetentionDays: 14
      geoRedundantBackup: 'Disabled'
    }
    highAvailability: {
      mode: 'Disabled'
    }
  }
}

resource mysqlDatabase 'Microsoft.DBforMySQL/flexibleServers/databases@2021-05-01' = {
  parent: mysqlServer
  name: 'umami'
  properties: {
    charset: 'utf8'
    collation: 'utf8_general_ci'
  }
}
