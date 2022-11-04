# Swordfish

Swordfish is a POC static contract analysis tool built on Foundry. This implementation includes analysis of an ERC721 smart contract and whether it blocks transfers by an operator that does not enforce creator fees.

For the POC and quick integration, I'm using a lightweight Go server to run CLI commands and return the validation response.

## Usage

```bash
./validate.sh <contract_address> <token_id>

# Arguments
#   contract_address: The smart contract being validated
#   token_id: A token id to use as the simulation

# Returns
#   1: Contract enforces creator fees
#   0: Contract does not enforce creator fees
```

Note: If we figure out how to cheatcode the ERC721 storage in forge, we can remove the `token_id` requirement.

## Testing Swordfish

```bash
forge install

# Test with QQL Mint Pass which has blocked X2Y2
./validate.sh https://api.mycryptoapi.com/eth 0xc73B17179Bf0C59cD5860Bb25247D1D1092c1088 994
# 1

# Test with BAYC which can never block X2Y2
./validate.sh https://api.mycryptoapi.com/eth 0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d 2368
# 0

```

## Example Server

```bash

docker build -t swordfish .

docker run -p 9000:5000 swordfish
```

Valid Request

```
curl -XPOST "http://localhost:9000/validate" -H "Content-Type: application/json" -d '{"rpcUrl": "https://api.mycryptoapi.com/eth", "contractAddress": "0xc73B17179Bf0C59cD5860Bb25247D1D1092c1088", "tokenId": "994"}'
```

Invalid Request

```
curl -XPOST "http://localhost:9000/validate" -H "Content-Type: application/json" -d '{"rpcUrl": "https://api.mycryptoapi.com/eth", "contractAddress": "0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d", "tokenId": "2368"}'
```
