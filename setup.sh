#!/bin/bash
resource=`az group list --query '[0].name' --output tsv`

az network vnet create /
  --name usVNet1 \
  --resource-group $resource \
  --address-prefix 10.11.0.0/16 \
  --location eastus \
  --subnet-name FrontEnd \
  --subnet-prefix 10.11.0.0/24

az network vnet update \
  --name usVNet1 \
  --address-prefixes 10.11.0.0/16 10.12.0.0/16 \
  --resource-group $resource

az network vnet subnet create \
  --vnet-name usVNet1 \
  --name BackEnd \
  --resource-group $resource \
  --address-prefix 10.12.0.0/24

az network vnet subnet create \
  --vnet-name usVNet1 \
  --name GatewaySubnet \
  --resource-group $resource \
  --address-prefix 10.12.255.0/27

az network public-ip create \
  --name VNet1GWIP \
  --resource-group $resource \
  --allocation-method Dynamic

az network vnet-gateway create \
  --name VNet1GW \
  --location eastus \
  --public-ip-address VNet1GWIP \
  --resource-group $resource1 \
  --vnet usVNet1 \
  --gateway-type Vpn \
  --sku VpnGw1 \
  --vpn-type RouteBased \
  --no-wait

printf "***********************  Virtual Network 1 created *********************\n\n"

az network vnet create /
  --name ukVNet2 \
  --resource-group $resource \
  --address-prefix 10.11.0.0/16 \
  --location uksouth \
  --subnet-name FrontEnd \
  --subnet-prefix 10.11.0.0/24

az network vnet update \
  --name ukVNet2 \
  --address-prefixes 10.11.0.0/16 10.12.0.0/16 \
  --resource-group $resource

az network vnet subnet create \
  --vnet-name ukVNet2 \
  --name BackEnd \
  --resource-group $resource \
  --address-prefix 10.12.0.0/24

az network vnet subnet create \
  --vnet-name ukVNet2 \
  --name GatewaySubnet \
  --resource-group $resource \
  --address-prefix 10.12.255.0/27

az network public-ip create \
  --name VNet2GWIP \
  --resource-group $resource \
  --allocation-method Dynamic

az network vnet-gateway create \
  --name VNet2GW \
  --location uksouth \
  --public-ip-address VNet2GWIP \
  --resource-group $resource \
  --vnet ukVNet2 \
  --gateway-type Vpn \
  --sku VpnGw1 \
  --vpn-type RouteBased \
  --no-wait

printf "***********************  Virtual Network 2 created *********************\n\n"

az network vpn-connection create \
  --name VNet1ToVNet2 \
  --resource-group $resource \
  --vnet-gateway1 VNet1GW \
  --location eastus \
  --shared-key "s3cur3keys" \
  --vnet-gateway2 VNet2GW

az network vpn-connection create \
  --name VNet2ToVNet1 \
  --resource-group $resource \
  --vnet-gateway1 VNet2GW \
  --location uksouth \
  --shared-key "s3cur3k3ys" \
  --vnet-gateway2 VNet1GW