module vnet './modules/virtual-network.bicep' = {
  name: 'vnet-deployment'
  params: {}
}

param stName string = 'st${uniqueString(resourceGroup().id)}'
module storage './modules/storage-accounts.bicep' = {
  name: 'storage-deployment'
}

param containerAppsEnvironmentName string = 'cae-${uniqueString(resourceGroup().id)}'
module containerAppsEnvironment './modules/container-apps-environments.bicep' = {
  name: 'containerappsenv-deployment'
  params: {
    name: containerAppsEnvironmentName
    storageAccountName: storage.outputs.storageAccountName
    storageAccountKey: storage.outputs.storageAccountKey
    fileShareName: storage.outputs.fileShareName
  }
}

module containerApps './modules/container-apps.bicep' = {
  name: 'containerapp-deployment'
  params: {
    containerAppsEnvironmentName: containerAppsEnvironmentName
  }
  dependsOn: [
    containerAppsEnvironment
  ]
}
