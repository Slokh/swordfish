#!/bin/bash

CONTRACT_ADDRESS=$1
TOKEN_ID=$2

export CONTRACT_ADDRESS=$CONTRACT_ADDRESS
export TOKEN_ID=$TOKEN_ID

forge install

# Test
OUTPUT=$(forge test)

# Naive check for POC
if [[ $OUTPUT == *"; 0 failed"* ]]; then
  echo 1
else
    echo 0
fi
