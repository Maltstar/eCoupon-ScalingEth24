// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract DiscountCoupons is Ownable, ERC1155Supply, ERC1155Burnable {
  constructor(address initialOwner) ERC1155("") Ownable(initialOwner) {}

  struct Vendor {
    address vendorAddress;
    string name;
    string storeLink;
  }
  
  mapping(uint vendorID => Vendor) public vendors;
  mapping(uint vendorID => uint[] couponCollectionsByVendor) public vendorCouponCollections;
  uint public vendorIDCounter = 0;

  struct CouponCollectionData {
    uint vendorID;
    uint256 discount;
    uint256 price;
    uint maxCouponAmount;
  }

  mapping(uint couponCollectionID => CouponCollectionData) public couponCollections;
  uint public couponCollectionIDCounter;

  function updateVendor(uint vendorID, string memory name, string memory storeLink) external {
    require(vendors[vendorID].vendorAddress == msg.sender, "Only vendor can update its data");
    vendors[vendorID].name = name;
    vendors[vendorID].storeLink = storeLink;
  }

  function listCouponCollection(string memory name, string memory storeLink, uint vendorID, uint256 discount, uint256 price, uint maxCouponAmount) external {
    vendors[vendorIDCounter] = Vendor(msg.sender, name, storeLink);

    couponCollections[couponCollectionIDCounter] = CouponCollectionData(vendorIDCounter, discount, price, maxCouponAmount);
    vendorCouponCollections[vendorIDCounter].push(couponCollectionIDCounter);
    
    vendorIDCounter++;
    couponCollectionIDCounter++;
  }

  function updateCouponCollection(uint256 couponCollectionID, uint256 discount, uint256 price, uint maxCouponAmount) external {
    require(vendors[couponCollections[couponCollectionID].vendorID].vendorAddress == msg.sender, "Only vendor can update its coupon collection");

    couponCollections[couponCollectionID].discount = discount;
    couponCollections[couponCollectionID].price = price;
    couponCollections[couponCollectionID].maxCouponAmount = maxCouponAmount;
  }
}