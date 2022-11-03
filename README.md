# Swordfish

Swordfish is a POC static contract analysis tool built on Foundry. This implementation includes analysis of an ERC721 smart contract and whether it blocks transfers by an operator that does not enforce creator fees.

## Usage

Note: The simulation parameters are only temporary until we figure out how to update storage via cheatcodes.

```bash
./validate.sh <contract_address> <simulation_token_id> <simulation_block_number>
```

**Returns**

- 1: Contract enforces creator fees
- 0: Contract does not enforce creator fees

## Testing Swordfish

```bash
forge install

export ETH_RPC_URL=https://api.mycryptoapi.com/eth

# Test with QQL Mint Pass which has blocked X2Y2
./validate.sh 0xc73B17179Bf0C59cD5860Bb25247D1D1092c1088 994
# 1

# Test with BAYC which can never block X2Y2
./validate.sh 0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d 2368
# 0

```
