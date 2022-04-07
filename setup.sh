#!/bin/bash
resource=`az group list --query '[0].name' --output tsv`

az vm create \
  --resource-group $resource \
  --name virtualMachine1 \
  --location westus \
  --image UbuntuLTS \
  --admin-username azureuser \
  --public-ip-sku Standard \
  --generate-ssh-keys

az vm open-port \
--port 22 \
--resource-group $resource \
--name virtualMachine1

az vm create \
  --resource-group $resource \
  --name virtualMachine2 \
  --location uksouth \
  --image UbuntuLTS \
  --admin-username azureuser \
  --public-ip-sku Standard \
  --generate-ssh-keys

az vm open-port \
--port 22 \
--resource-group $resource \
--name virtualMachine2
