param name string = 'vnet-${uniqueString(resourceGroup().id)}'
param vnetAddressPrefix string = '10.10.0.0/16'
param subnetAddressPrefixContainerAppsEnvironment string = '10.10.2.0/23'
resource vnet 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: name
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: []
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  parent: vnet
  name: 'snet-cae'
  properties: {
    addressPrefixes: [
      subnetAddressPrefixContainerAppsEnvironment
    ]
    delegations: [
      {
        name: 'Microsoft.App/environments'
        properties: {
          serviceName: 'Microsoft.App/environments'
        }
      }
    ]
    serviceEndpoints: [
      {
        service: 'Microsoft.KeyVault'
        locations: [
          '*'
        ]
      }
    ]
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

output subnetId string = subnet.id
