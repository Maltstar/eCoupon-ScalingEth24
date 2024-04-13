// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract DiscountCoupons is ERC1155, Ownable, ERC1155Burnable, ERC1155Supply {
  constructor(address initialOwner) ERC1155("") Ownable(initialOwner) {}

  struct Vendor {
    address vendorAddress;
    string name;
    string storeLink;
  }
  
  mapping(uint vendorID => Vendor) vendors;
  mapping(uint vendorID => uint[] couponCollectionsByVendor) vendorCouponCollections;
  uint vendorIDCounter = 0;

  function registerVendor(string memory name, string memory storeLink) external {
    vendors[vendorIDCounter] = Vendor(msg.sender, name, storeLink);
    vendorIDCounter++;
  }

  function updateVendor(uint vendorID, string memory name, string memory storeLink) external {
    require(vendors[vendorID].vendorAddress == msg.sender, "Only vendor can update its data");
    vendors[vendorID].name = name;
    vendors[vendorID].storeLink = storeLink;
  }
}