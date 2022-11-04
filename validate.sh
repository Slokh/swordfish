#!/bin/bash

ETH_RPC_URL=$1
CONTRACT_ADDRESS=$2
TOKEN_ID=$3

export ETH_RPC_URL=$ETH_RPC_URL
export CONTRACT_ADDRESS=$CONTRACT_ADDRESS
export TOKEN_ID=$TOKEN_ID

~/.foundry/bin/forge install

# Test
OUTPUT=$(~/.foundry/bin/forge test)

# Naive check for POC
if [[ $OUTPUT == *"; 0 failed"* ]]; then
  echo 1
else
    echo 0
fi
