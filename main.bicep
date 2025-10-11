param logName string = 'log-${uniqueString(resourceGroup().id)}'
module log './modules/log-analytics.bicep' = {
  name: 'loganalytics-deployment'
  params: {
    name: logName
  }
}

param vnetName string = 'vnet-${uniqueString(resourceGroup().id)}'
param vnetAddressPrefix string = '10.10.0.0/16'
param subnetNameContainerAppsEnvironment string = 'snet-cae'
param subnetNamePrivateEndpoint string = 'snet-pep'
param subnetAddressPrefixContainerAppsEnvironment string = '10.10.2.0/23'
param subnetAddressPrefixPrivateEndpoint string = '10.10.1.0/24'
module vnet './modules/virtual-network.bicep' = {
  name: 'vnet-deployment'
  params: {
    name: vnetName
    vnetAddressPrefix: vnetAddressPrefix
    subnetNameContainerAppsEnvironment: subnetNameContainerAppsEnvironment
    subnetNamePrivateEndpoint: subnetNamePrivateEndpoint
    subnetAddressPrefixContainerAppsEnvironment: subnetAddressPrefixContainerAppsEnvironment
    subnetAddressPrefixPrivateEndpoint: subnetAddressPrefixPrivateEndpoint
  }
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
    subnetId: vnet.outputs.subnetContainerAppsEnvironmentId
    fileShareSandboxName: storage.outputs.fileShareDifySandboxName
    fileShareNginxName: storage.outputs.fileShareNginxName
    fileShareSsrfProxyName: storage.outputs.fileShareSsrfProxyName
    logAnalyticsWorkspaceName: log.outputs.logAnalyticsWorkspaceName
  }
}

module containerApps './modules/container-apps.bicep' = {
  name: 'containerapp-deployment'
  params: {
    containerAppsEnvironmentName: containerAppsEnvironmentName
    storageName: containerAppsEnvironment.outputs.storageName
    storageDifySandboxName: containerAppsEnvironment.outputs.storageDifySandboxName
    storageNginxName: containerAppsEnvironment.outputs.storageNginxName
    storageSsrfProxyName: containerAppsEnvironment.outputs.storageSsrfProxyName
  }
}
