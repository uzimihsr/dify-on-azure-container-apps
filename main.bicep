param containerAppsEnvironmentName string = 'cae-${uniqueString(resourceGroup().id)}'
module containerAppsEnvironment './modules/container-apps-environments.bicep' = {
  name: 'containerappsenv-deployment'
  params: {
    name: containerAppsEnvironmentName
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
