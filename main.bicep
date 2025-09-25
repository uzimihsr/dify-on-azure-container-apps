param containerAppsEnvironmentName string = 'cae-${uniqueString(resourceGroup().id)}'
module containerAppsEnvironment './modules/container-apps-environments.bicep' = {
  name: 'containerappsenv-deployment'
  params: {
    name: containerAppsEnvironmentName
  }
}
