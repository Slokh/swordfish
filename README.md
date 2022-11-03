# Swordfish

Swordfish is a POC static contract analysis tool built upon Foundry. This implementation includes analysis of an ERC721 smart contract and whether it blocks transfers by an operator that does not enforce creator fees.

# Testing Swordfish

```bash
# Install
forge install

# Config
source config.env

# Test
forge test
```
