# English auction for NFT.


### Auction

- Seller of NFT deploys this contract.
- Auction lasts for specific time.
- Participants can bid by depositing ETH greater than the current highest bidder.
- All bidders can withdraw their bid if it is not the current highest bid.

### After the auction

- Highest bidder becomes the new owner of NFT.
- The seller receives the highest bid of ETH.


## Installation

```shell
yarn hardhat 
yarn hardhat compile
yarn hardhat node
yarn hardhat deploy
```

