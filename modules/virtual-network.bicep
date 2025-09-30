param name string = 'vnet-${uniqueString(resourceGroup().id)}'
param vnetAddressPrefix string = '10.99.0.0/16'
param subnetAddressPrefixContainerAppsEnvironment string = '10.99.2.0/23'
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
    subnets: [
      {
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
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}
