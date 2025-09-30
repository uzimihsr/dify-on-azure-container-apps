param name string
param storageAccountName string
param storageAccountKey string
param fileShareName string
param subnetId string

var storageName = 'dify-app-storage'

resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2025-02-02-preview' = {
  name: name
  location: resourceGroup().location
  properties: {
    workloadProfiles: [
      {
        name: 'Consumption'
        workloadProfileType: 'Consumption'
      }
    ]
    vnetConfiguration: {
      infrastructureSubnetId: subnetId
    }
  }
}

resource containerAppsEnvironmentStorage 'Microsoft.App/managedEnvironments/storages@2025-02-02-preview' = {
  parent: containerAppsEnvironment
  name: storageName
  properties: {
    azureFile: {
      accountName: storageAccountName
      accountKey: storageAccountKey
      shareName: fileShareName
      accessMode: 'ReadWrite'
    }
  }
}

output storageName string = storageName
