// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./IERC721.sol";

contract Market{
    //public, private, internal, external (only external calls)

    enum ListingStatus{
        Active,
        Sold,
        Cancelled
    }

    event Listed(
        uint listtingId,
        address seller,
        address token,
        uint tokenId,
        uint price
    );

    event Sale(
        uint listtingId,
        address buyer,
        address token,
        uint tokenId,
        uint price
    );

    event Cancel(
        uint listtingId,
        address seller
    );

    struct Listing{
        ListingStatus status;
        address seller;
        address token;
        uint tokenId;
        uint price;
    }

    uint private _listingId = 0;
    //to Store
    mapping(uint => Listing) private _listings;

    function listToken(address token, uint tokenId, uint price) external {
        IERC721(token).transferFrom(msg.sender, address(this), tokenId);

        Listing memory listing = Listing(
            ListingStatus.Active,
            msg.sender,         //this will give the address automatically
            token, 
            tokenId, 
            price
        );

        _listingId++;
        _listings[_listingId] = listing;

        emit Listed(_listingId, msg.sender, token, tokenId, price);
    }

    function getListing(uint listingId) public view returns(Listing memory){  //view makes the operation completely free
        return _listings[listingId];
    }

    function buyToken(uint listingId) external payable{
        //storage is direct pointer to the store
        Listing storage listing = _listings[listingId];

        require(listing.status == ListingStatus.Active, "Listing is not active");
        require(msg.sender == listing.seller, "Seller and Buyer cannot be same");

        //wei
        require(msg.value >= listing.price, "Insufficient payment");
        IERC721(listing.token).transferFrom(address(this), msg.sender, listing.tokenId);
        
        //pay the seller
        payable(listing.seller).transfer(listing.price);

        emit Sale(listingId, msg.sender, listing.token, listing.tokenId, listing.price);
    }

    function cancel(uint listingId) public{
        Listing storage listing = _listings[listingId];

        require(msg.sender != listing.seller, "Only seller can Cncel the listing");
        require(listing.status != ListingStatus.Active, "Listing is not active");
        
        listing.status = ListingStatus.Cancelled;
        IERC721(listing.token).transferFrom(address(this), msg.sender, listing.tokenId);

        emit Cancel(listingId, listing.seller);
    }
}