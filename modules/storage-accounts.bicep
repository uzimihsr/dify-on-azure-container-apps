param name string = 'st${uniqueString(resourceGroup().id)}'
param fileShareNameDifyApi string = 'volume-dify-api'
param fileShareNameDifySandbox string = 'volume-dify-sandbox'
param fileShareNameDifyPluginDaemon string = 'volume-dify-plugin-daemon'
param fileShareNameNginx string = 'volume-nginx'
param fileShareNameSsrfProxy string = 'volume-ssrf-proxy'
param vnetName string
param subnetName string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-07-01' existing = {
  name: vnetName
}
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' existing = {
  parent: virtualNetwork
  name: subnetName
}

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

// プライベートDNSゾーン - File
resource fileDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.file.${environment().suffixes.storage}'
  location: 'global'
}

// 仮想ネットワークリンク - File
resource fileVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'file-dns-link'
  parent: fileDnsZone
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetwork.id
    }
  }
}

// プライベートエンドポイント - File
resource filePrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-05-01' = {
  name: 'pep-file-${name}'
  location: resourceGroup().location
  properties: {
    subnet: {
      id: subnet.id
    }
    privateLinkServiceConnections: [
      {
        name: 'psc-file'
        properties: {
          privateLinkServiceId: storageAccount.id
          groupIds: [
            'file'
          ]
        }
      }
    ]
  }
}

// プライベートエンドポイントDNSグループ - File
resource filePrivateEndpointDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-05-01' = {
  name: 'pdz-file'
  parent: filePrivateEndpoint
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'config1'
        properties: {
          privateDnsZoneId: fileDnsZone.id
        }
      }
    ]
  }
}

output storageAccountName string = storageAccount.name
output fileShareDifyApiName string = fileShareDifyApi.name
output fileShareDifySandboxName string = fileShareDifySandbox.name
output fileShareNginxName string = fileShareNginx.name
output fileShareSsrfProxyName string = fileShareSsrfProxy.name
