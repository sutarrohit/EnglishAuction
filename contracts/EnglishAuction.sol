//SPDX-License-Identifier:MIT
pragma solidity ^0.8.17;

interface IERC721 {
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external;
}

contract EnglishAuction {
    //Events
    event Start();
    event Bid(address Bider, uint256 amount);
    event Withdraw(address Bider, uint256 amount);
    event End(address highestBider, uint256 Bid);

    //NFT Variables
    IERC721 public immutable nftContract;
    uint256 public immutable nftId;

    //State variables
    address payable public immutable seller;
    uint32 public endAt;
    bool public auctionStarted;
    bool public auctionEnded;

    address public highestBider;
    uint256 public highestBid;

    //Mappping
    mapping(address => uint256) public bids;

    constructor(
        address _nftAddress,
        uint256 _nftId,
        uint256 _startingBid
    ) {
        nftContract = IERC721(_nftAddress);
        nftId = _nftId;
        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    //startAuction function start Auction
    function startAuction() public {
        require(msg.sender == seller, "Not Seller");
        require(!auctionStarted, "Auction Already Started");

        auctionStarted = true;
        endAt = uint32(block.timestamp + 160);
        nftContract.transferFrom(seller, address(this), nftId);

        emit Start();
    }

    //bid function start bidding
    function bid() public payable {
        require(auctionStarted, "Auction not Startrd");
        require(!auctionEnded, "Auction Ends");
        require(msg.value > highestBid);

        highestBider = msg.sender;
        highestBid = msg.value;
        bids[msg.sender] += msg.value;

        emit Bid(msg.sender, msg.value);
    }

    //Bidder withdraw their funds
    function withdraw() external {
        uint256 balance = bids[msg.sender];
        require(balance > 0 && msg.sender != highestBider, "You are not bider");

        bids[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Transaction Failed");

        emit Withdraw(msg.sender, balance);
    }

    //End Auction
    function end() external {
        require(auctionStarted, "Auction not Startrd");
        require(!auctionEnded, "Auction Ends");
        require(block.timestamp >= endAt, "not ended");

        auctionEnded = true;

        if (highestBider != address(0)) {
            nftContract.transferFrom(address(this), highestBider, nftId);
            (bool success, ) = seller.call{value: highestBid}("");
            require(success, "Transction Failed");
        } else {
            nftContract.transferFrom(address(this), seller, nftId);
        }

        emit End(highestBider, highestBid);
    }
}
