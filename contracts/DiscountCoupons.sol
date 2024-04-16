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
    string name;
    uint256 discount;
    uint maxCouponAmount;
    uint expirationDate;
  }

  mapping(uint couponCollectionID => CouponCollectionData) public couponCollections;
  uint public couponCollectionIDCounter;

  function updateVendor(uint vendorID, string memory name, string memory storeLink) external {
    require(vendors[vendorID].vendorAddress == msg.sender, "Only vendor can update its data");
    vendors[vendorID].name = name;
    vendors[vendorID].storeLink = storeLink;
  }

  function listCouponCollection(string memory vendorName, string memory storeLink, string memory couponName, uint256 discount, uint maxCouponAmount, uint expirationDate) external {
    vendors[vendorIDCounter] = Vendor(msg.sender, vendorName, storeLink);

    couponCollections[couponCollectionIDCounter] = CouponCollectionData(vendorIDCounter, couponName, discount, maxCouponAmount, expirationDate);
    vendorCouponCollections[vendorIDCounter].push(couponCollectionIDCounter);
    
    vendorIDCounter++;
    couponCollectionIDCounter++;
  }

  function updateCouponCollection(uint256 couponCollectionID, string memory name, uint256 discount, uint maxCouponAmount, uint expirationDate) external {
    require(vendors[couponCollections[couponCollectionID].vendorID].vendorAddress == msg.sender, "Only vendor can update its coupon collection");

    couponCollections[couponCollectionID].name = name;
    couponCollections[couponCollectionID].discount = discount;
    couponCollections[couponCollectionID].maxCouponAmount = maxCouponAmount;
    couponCollections[couponCollectionID].expirationDate = expirationDate;
  }

  function _update(address from, address to, uint256[] memory ids, uint256[] memory values) internal override(ERC1155Supply, ERC1155) virtual {
    super._update(from, to, ids, values);
  }

  function mintCoupon(uint256 couponCollectionID) external {
    _mint(msg.sender, couponCollectionID, 1, "");
  }
}