pragma solidity ^0.8.24;

interface DiscountCoupons {
  struct CouponCollectionData {
    uint vendorID;
    uint256 discount;
    uint256 price;
    uint maxCouponAmount;
  }

  struct Vendor {
    string name;
    string storeLink;
  }

  mapping(uint vendorID => Vendor) vendors;
  mapping(uint vendorID => uint[] couponCollectionsByVendor) vendorCouponCollections;
  uint vendorIDCounter;


  mapping(uint couponCollectionID => CouponCollectionData) couponCollections;
  uint couponCollectionIDCounter;

  // check if counter is present in ERC1155
  // uint couponIDCounter;

  function registerVendor(string memory name, string memory storeLink) external;
  function listCouponCollection(bytes memory couponCollectionData) external;
  function updateCouponCollection(uint256 couponCollectionID, bytes memory couponCollectionData) external;
  function pauseCouponCollection(uint256 couponCollectionID) external;
  function unpauseCouponCollection(uint256 couponCollectionID) external;
  function mintCoupon(uint256 couponCollectionID) external;
  function useCoupon(uint256 couponCollectionID, uint couponID) external; // maybe we need to recieve data here
  function transformCouponToNFT(uint256 couponCollectionID, uint couponID) external;

  function vendors(uint vendorID) external view returns (Vendor memory);
  function vendorIDCounter() external view returns (uint);
  function vendorCouponCollections(uint vendorID) external view returns (uint[] memory);
  function couponCollections(uint couponCollectionID) external view returns (CouponCollectionData memory);
  function couponCollectionIDCounter() external view returns (uint);
}