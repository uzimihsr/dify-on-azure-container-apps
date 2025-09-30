param storageAccountName string = 'st${uniqueString(resourceGroup().id)}'
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
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

resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-01-01' = {
  parent: fileService
  name: 'dify-storage'
  properties: {
    shareQuota: 5120
  }
}

resource fileShareDifySandbox 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-01-01' = {
  parent: fileService
  name: 'dify-sandbox'
  properties: {
    shareQuota: 5120
  }
}

resource fileShareNginx 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-01-01' = {
  parent: fileService
  name: 'volume-nginx'
  properties: {
    shareQuota: 5120
  }
}

output storageAccountName string = storageAccount.name
output storageAccountKey string = storageAccount.listKeys().keys[0].value
output fileShareName string = fileShare.name
output fileShareDifySandboxName string = fileShareDifySandbox.name
output fileShareNginxName string = fileShareNginx.name
