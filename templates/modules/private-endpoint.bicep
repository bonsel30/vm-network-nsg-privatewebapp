@description('Default location is location of resourcegroup')
param parlocation string //= resourceGroup().location
param parsubnetid string 
param parZonename string
param parprivateendpointDNSZoneid string
param parappServiceid string

param parprivatelinklinkname string = 'pl${uniqueString(resourceGroup().id)}'

resource resprivateendpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: parprivatelinklinkname
  location:parlocation
  properties:{
    
    subnet:{
      id:parsubnetid
    }
    privateLinkServiceConnections:[
      {
        properties:{
          privateLinkServiceId:parappServiceid
          groupIds:[
            'sites'
          ]

        }
        id:parappServiceid
        name:parprivatelinklinkname
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


output outprivateendpointname string = resprivateendpoint.name
output outprivateendpointide string = resprivateendpoint.id
