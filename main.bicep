module vnet './modules/virtual-network.bicep' = {
  name: 'vnet-deployment'
  params: {}
}

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
    subnetId: vnet.outputs.subnetId
    fileShareSandboxName: storage.outputs.fileShareDifySandboxName
    fileShareNginxName: storage.outputs.fileShareNginxName
  }
}

module containerApps './modules/container-apps.bicep' = {
  name: 'containerapp-deployment'
  params: {
    containerAppsEnvironmentName: containerAppsEnvironmentName
    storageName: containerAppsEnvironment.outputs.storageName
    storageDifySandboxName: containerAppsEnvironment.outputs.storageDifySandboxName
    storageNginxName: containerAppsEnvironment.outputs.storageNginxName
  }
}
