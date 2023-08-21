//Targetscope is subscription, we are creating resourcegroups here.
//After creating resource groups, we are calling modules to create resources.
targetScope = 'subscription'


@description('name of the project used as prefix for resources')
param parProjectNamePrefix string = 'testapp-aug-2023'

@description('Specifies the location for resources.')
@allowed([
  'westeurope'
  'northeurope'
])
param parLocation string

@secure()
param parserver2019adminname string
@secure()
param parserver2019password string

param parwhatismyip string

resource resNetworkRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${parProjectNamePrefix}-NetWorkresourcegroup'
  location: parLocation
}

resource resVmRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${parProjectNamePrefix}-VMresourcegroup'
  location: parLocation
}

resource resAppsServicePlanRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${parProjectNamePrefix}-WebAppesourcegroup'
  location: parLocation
}


module modvnetworkinfo 'modules/vnetwithsng.bicep' = {
  scope:resNetworkRG  
  name: 'vnetworkmodule'
  params: {
    parlocation: parLocation
    parwhatismyip: parwhatismyip
      }
}

module modprivatednszones 'modules/dnszones.bicep' = {
  scope: resNetworkRG
  name: 'privatednszonesmodule'
  params: {
    parvirtualnetworkid: modvnetworkinfo.outputs.vnetid
    parZonename: 'privatelink.azurewebsites.net'
  }
}

module modpupipinfo 'modules/pupblicip.bicep' = {
  scope:resVmRG
  name: 'publicpipmodule'
  params: {
    parlocation: parLocation
      }
}

module modwebappinfo 'modules/Webapp.bicep' = {
  scope: resAppsServicePlanRG
  dependsOn:[
    modvnetworkinfo
  ]
  name: 'webappmodule'
  params: {
    parlocation:parLocation
    parprivateendpointDNSZoneid: modprivatednszones.outputs.websitednszoneid
    parsubnet2id: modvnetworkinfo.outputs.subnet2id
    parZonename: modprivatednszones.outputs.websitednszonename
    
  }
}

module vminfo 'modules/vm.bicep' = {
  scope:resVmRG
  name: 'vminfomodule'
  params: {
    parserver2019adminname: parserver2019adminname
    parserver2019password: parserver2019password
    parlocation:parLocation
    parpublicip:modpupipinfo.outputs.publicipid
    parsubnet1id:modvnetworkinfo.outputs.subnet1id
  }
}
