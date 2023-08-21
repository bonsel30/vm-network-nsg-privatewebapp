param parlocation string 
param parwhatismyip string

resource resnsg 'Microsoft.Network/networkSecurityGroups@2020-07-01' = {
  name: 'nsgjb1'
  location: parlocation
  tags: {}
  properties: {
    securityRules:[
      {
        name:'rule1'
        properties:{
          access: 'Allow'
          protocol: 'Tcp'
          direction: 'Inbound'
          description:'allow rdp'
          sourceAddressPrefixes:[
            parwhatismyip
          ]
          destinationAddressPrefixes:[
            '10.0.1.0/24'
            ]
          priority:2000
          destinationPortRange:'3389'
          sourcePortRange:'*'

        }
      }
    ]
    
  }
}

resource resvnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'vnetjb1'
  location:parlocation
  properties:{
    addressSpace:{
      addressPrefixes:[
        '10.0.0.0/16'
      ]
    }
    subnets:[
    {
      name:'subnet1'
      properties:{
        addressPrefix:'10.0.1.0/24'
        networkSecurityGroup:{
          id:resnsg.id
        }
      }
    }
        {
      name:'subnet2'
      properties:{
        addressPrefix:'10.0.2.0/24'
        networkSecurityGroup:{
          id:resnsg.id
        }
      }
    }
    ]
  }
  
}

output subnet1id string = resvnet.properties.subnets[0].id
output subnet1name string = resvnet.properties.subnets[0].name

output subnet2id string = resvnet.properties.subnets[1].id
output subnet2name string = resvnet.properties.subnets[1].name

output vnetid string = resvnet.id
output vnetname string = resvnet.name
