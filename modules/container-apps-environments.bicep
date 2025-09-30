param name string
param storageAccountName string
param storageAccountKey string
param fileShareName string
param fileShareSandboxName string
param fileShareNginxName string
param subnetId string
param logAnalyticsWorkspaceName string

var storageName = 'dify-app-storage'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = {
  name: logAnalyticsWorkspaceName
}

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
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspace.properties.customerId
        dynamicJsonColumns: false
        sharedKey: logAnalyticsWorkspace.listKeys().primarySharedKey
      }
    }
  }
}

resource storageDifyApp 'Microsoft.App/managedEnvironments/storages@2025-02-02-preview' = {
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

resource storageDifySandbox 'Microsoft.App/managedEnvironments/storages@2025-02-02-preview' = {
  parent: containerAppsEnvironment
  name: 'volume-dify-sandbox'
  properties: {
    azureFile: {
      accountName: storageAccountName
      accountKey: storageAccountKey
      shareName: fileShareSandboxName
      accessMode: 'ReadWrite'
    }
  }
}

resource storageNginx 'Microsoft.App/managedEnvironments/storages@2025-02-02-preview' = {
  parent: containerAppsEnvironment
  name: 'volume-nginx'
  properties: {
    azureFile: {
      accountName: storageAccountName
      accountKey: storageAccountKey
      shareName: fileShareNginxName
      accessMode: 'ReadWrite'
    }
  }
}

output storageName string = storageName
output storageDifySandboxName string = storageDifySandbox.name
output storageNginxName string = storageNginx.name
