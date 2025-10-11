param logName string = 'log-${uniqueString(resourceGroup().id)}'
// module log './modules/log-analytics.bicep' = {
//   name: 'loganalytics-deployment'
//   params: {
//     name: logName
//   }
// }

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

param stName string = 'st${uniqueString(resourceGroup().id)}'
param fileShareNameDifyApi string = 'volume-dify-api'
param fileShareNameDifySandbox string = 'volume-dify-sandbox'
param fileShareNameDifyPluginDaemon string = 'volume-dify-plugin-daemon'
param fileShareNameNginx string = 'volume-nginx'
param fileShareNameSsrfProxy string = 'volume-ssrf-proxy'
module storage './modules/storage-accounts.bicep' = {
  name: 'storage-deployment'
  params: {
    name: stName
    vnetName: vnetName
    subnetName: subnetNamePrivateEndpoint
    fileShareNameDifyApi: fileShareNameDifyApi
    fileShareNameDifySandbox: fileShareNameDifySandbox
    fileShareNameDifyPluginDaemon: fileShareNameDifyPluginDaemon
    fileShareNameNginx: fileShareNameNginx
    fileShareNameSsrfProxy: fileShareNameSsrfProxy
  }
  dependsOn: [
    vnet
  ]
}

param caeName string = 'cae-${uniqueString(resourceGroup().id)}'
module containerAppsEnvironment './modules/container-apps-environments.bicep' = {
  name: 'containerappsenv-deployment'
  params: {
    name: caeName
    stName: stName
    logName: logName
    vnetName: vnetName
    subnetName: subnetNameContainerAppsEnvironment
    fileShareNameDifyApi: fileShareNameDifyApi
    fileShareNameDifySandbox: fileShareNameDifySandbox
    fileShareNameDifyPluginDaemon: fileShareNameDifyPluginDaemon
    fileShareNameNginx: fileShareNameNginx
    fileShareNameSsrfProxy: fileShareNameSsrfProxy
  }
  dependsOn: [
    storage
  ]
}

module containerApps './modules/container-apps.bicep' = {
  name: 'containerapp-deployment'
  params: {
    containerAppsEnvironmentName: caeName
    storageNameSsrfProxy: fileShareNameSsrfProxy
    storageNameDifySandbox: fileShareNameDifySandbox
    storageNameDifyApi: fileShareNameDifyApi
    storageNameDifyPluginDaemon: fileShareNameDifyPluginDaemon
    storageNameNginx: fileShareNameNginx
  }
}
