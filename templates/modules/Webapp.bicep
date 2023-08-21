
@description('Default location is location of resourcegroup')
param parlocation string 

param parwebAppName string = uniqueString(resourceGroup().id) // Generate unique String for web app name
param parsku string = 'B1' // The SKU of App Service Plan
param linuxFxVersion string = 'node|18-lts' // The runtime stack of web app

param parsubnet2id string 
param parZonename string
param parprivateendpointDNSZoneid string
param parprivatelinklinkname string = 'pl${uniqueString(resourceGroup().id)}'

param repositoryUrl string = 'https://github.com/Azure-Samples/nodejs-docs-hello-world'
param branch string = 'main'

var varappServicePlanName = toLower('AppServicePlan-${parwebAppName}')
var varwebSiteName = toLower('wapp-${parwebAppName}')


resource resappServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: varappServicePlanName
  location: parlocation
  properties: {
    reserved: true
  }
  sku: {
    name: parsku
  }
  kind: 'linux'
}

resource resappService 'Microsoft.Web/sites@2020-06-01' = {
  name: varwebSiteName
  location: parlocation
  properties: {
    serverFarmId: resappServicePlan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
    }
  }

}

resource resprivateendpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: parprivatelinklinkname
  location:parlocation
  properties:{
    
    subnet:{
      id:parsubnet2id
    }
    privateLinkServiceConnections:[
      {
        properties:{
          privateLinkServiceId:resappService.id
          groupIds:[
            'sites'
          ]

        }
        name:'sc-web-${uniqueString(resourceGroup().id)}'
      }
    ]
    
  }
}

resource resPrivatelinkDNSzoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-07-01' = {
  parent:resprivateendpoint
  name: 'default'
  properties:{
    privateDnsZoneConfigs:[
      {
        name:parZonename
        properties:{
          privateDnsZoneId:parprivateendpointDNSZoneid
        }
      }
    ]
  }

}


resource ressrcControls 'Microsoft.Web/sites/sourcecontrols@2021-01-01' = {
  parent: resappService
  name: 'web' 
  properties: {
    repoUrl: repositoryUrl
    branch: branch
    isManualIntegration: true
  }
}



output appserviceplanid string = resappServicePlan.id
output outappServiceid string = resappService.id
