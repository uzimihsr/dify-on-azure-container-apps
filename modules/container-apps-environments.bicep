param name string
param stName string
param logName string
param vnetName string
param subnetName string
param fileShareNameDifyApi string
param fileShareNameDifySandbox string
param fileShareNameDifyPluginDaemon string
param fileShareNameNginx string
param fileShareNameSsrfProxy string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = {
  name: logName
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: stName
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-07-01' existing = {
  name: vnetName
}
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' existing = {
  parent: virtualNetwork
  name: subnetName
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
      infrastructureSubnetId: subnet.id
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

// 共通化
var azureFileProperties = {
  accountName: storageAccount.name
  accountKey: storageAccount.listKeys().keys[0].value
  accessMode: 'ReadWrite'
}

resource storageDifyApi 'Microsoft.App/managedEnvironments/storages@2025-02-02-preview' = {
  parent: containerAppsEnvironment
  name: fileShareNameDifyApi
  properties: {
    azureFile: union(azureFileProperties, { shareName: fileShareNameDifyApi })
  }
}

resource storageDifySandbox 'Microsoft.App/managedEnvironments/storages@2025-02-02-preview' = {
  parent: containerAppsEnvironment
  name: fileShareNameDifySandbox
  properties: {
    azureFile: union(azureFileProperties, { shareName: fileShareNameDifySandbox })
  }
}

resource storageDifyPluginDaemon 'Microsoft.App/managedEnvironments/storages@2025-02-02-preview' = {
  parent: containerAppsEnvironment
  name: fileShareNameDifyPluginDaemon
  properties: {
    azureFile: union(azureFileProperties, { shareName: fileShareNameDifyPluginDaemon })
  }
}

resource storageNginx 'Microsoft.App/managedEnvironments/storages@2025-02-02-preview' = {
  parent: containerAppsEnvironment
  name: fileShareNameNginx
  properties: {
    azureFile: union(azureFileProperties, { shareName: fileShareNameNginx })
  }
}

resource storageSsrfProxy 'Microsoft.App/managedEnvironments/storages@2025-02-02-preview' = {
  parent: containerAppsEnvironment
  name: fileShareNameSsrfProxy
  properties: {
    azureFile: union(azureFileProperties, { shareName: fileShareNameSsrfProxy })
  }
}

output storageDifyApiName string = storageDifyApi.name
output storageDifySandboxName string = storageDifySandbox.name
output storageNginxName string = storageNginx.name
output storageSsrfProxyName string = storageSsrfProxy.name
