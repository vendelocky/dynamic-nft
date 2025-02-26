## DYNAMIC NFT

This contract is creating a dynamic NFT using SVG to draw a color based on minted owner's public address.

**This project is built with Foundry**

### Install package
```
# using npm
npm install

# using yarn
yarn install
```

### Install Foundry
```
curl -L https://foundry.paradigm.xyz | bash

foundryup
```

### Start local chain
```
anvil
```

### Build and deploy
```
forge build

# this method is suggested for testing only with your tester wallet.
# alternatively, you can use a safer way to deploy a contract to avoid exposing your private key.

forge script <SCRIPT_PATH> --rpc-url <NETWORK> --private-key <PRIVATE_KEY> --broadcast

```

## Features
1. Mint NFT and get the Dynamic NFT with a color based from your public address
2. Transfer NFT and change the color to the new owner's public address

## Mint NFT
```
# this method is suggested for testing only with your tester wallet.
# alternatively, you can use a saver way to deploy a contract to avoid exposing your private key.

cast send <CONTRACT_ADDRESS> "mint(address)" <YOUR_PUBLIC_ADDRESS> --rpc-url <NETWORK> --private-key <PRIVATE_KEY>
```

After minting process is successful, go to `opensea.io` OR `testnets.opensea.io` to check your NFT in your address

## Transfer NFT
You can call the `transferFrom` function to transfer the NFT to another owner (as shown in the test file) OR you can transfer the NFT through `opensea.io` itself. It will automatically change the color once the ownership is transferred.

## Testing color
To check the SVG image color on browser, copy paste this to the browser
```
// ENCODED_BASE_64_DATA is the data after `data:application/json;base64,` until the end `=`
data:image/svg+xml;base64,<ENCODED_BASE_64_DATA>
```