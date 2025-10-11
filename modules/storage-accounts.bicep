param name string = 'st${uniqueString(resourceGroup().id)}'
param fileShareNameDifyApi string = 'volume-dify-api'
param fileShareNameDifySandbox string = 'volume-dify-sandbox'
param fileShareNameDifyPluginDaemon string = 'volume-dify-plugin-daemon'
param fileShareNameNginx string = 'volume-nginx'
param fileShareNameSsrfProxy string = 'volume-ssrf-proxy'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: name
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource fileService 'Microsoft.Storage/storageAccounts/fileServices@2023-01-01' = {
  parent: storageAccount
  name: 'default'
}

resource fileShareDifyApi 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-01-01' = {
  parent: fileService
  name: fileShareNameDifyApi
  properties: {
    shareQuota: 5120
  }
}

resource fileShareDifySandbox 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-01-01' = {
  parent: fileService
  name: fileShareNameDifySandbox
  properties: {
    shareQuota: 5120
  }
}

resource fileShareDifyPluginDaemon 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-01-01' = {
  parent: fileService
  name: fileShareNameDifyPluginDaemon
  properties: {
    shareQuota: 5120
  }
}

resource fileShareNginx 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-01-01' = {
  parent: fileService
  name: fileShareNameNginx
  properties: {
    shareQuota: 5120
  }
}

resource fileShareSsrfProxy 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-01-01' = {
  parent: fileService
  name: fileShareNameSsrfProxy
  properties: {
    shareQuota: 5120
  }
}

output storageAccountName string = storageAccount.name
output fileShareDifyApiName string = fileShareDifyApi.name
output fileShareDifySandboxName string = fileShareDifySandbox.name
output fileShareNginxName string = fileShareNginx.name
output fileShareSsrfProxyName string = fileShareSsrfProxy.name
