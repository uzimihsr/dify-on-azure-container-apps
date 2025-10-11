param name string = 'vnet-${uniqueString(resourceGroup().id)}'
param vnetAddressPrefix string = '10.10.0.0/16'
param subnetNameContainerAppsEnvironment string = 'snet-cae'
param subnetNamePrivateEndpoint string = 'snet-pep'
param subnetAddressPrefixContainerAppsEnvironment string = '10.10.2.0/23'
param subnetAddressPrefixPrivateEndpoint string = '10.10.1.0/24'
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

resource subnetContainerAppsEnvironment 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  parent: vnet
  name: subnetNameContainerAppsEnvironment
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

resource subnetPrivateEndpoint 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  parent: vnet
  name: subnetNamePrivateEndpoint
  properties: {
    addressPrefixes: [
      subnetAddressPrefixPrivateEndpoint
    ]
    delegations: []
    serviceEndpoints: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

output subnetContainerAppsEnvironmentId string = subnetContainerAppsEnvironment.id
output subnetPrivateEndpointId string = subnetPrivateEndpoint.id
