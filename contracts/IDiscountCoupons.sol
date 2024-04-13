pragma solidity ^0.8.24;

// 1. Vendor can list new coupon.
    // Max. Coupon Amount
        // Mapping
    // Name
    // Discount
    // Price (0 default in MVP)
    // 
// 2. Vendor can update coupon parameters.
// 3. User can mint coupon.
// 4. mapping(id => CouponData)
// 5. List of vendors. VendorID, Name, Store Link. Mappinmg (addresss Vendor => struct)
// 6. Vendor will get vendor ID on first coupon listing.
// 7. User use coupon to get discount.
// 8. Mapping (vendorID => list of vendor coupon collections). To simplify life of frontend.

// 

// Second contract - Payment processor + Coupon Execution
// 1. Accept ERC20.
// 2. Accept coupon.
// 3. Verify coupon.
// 4. Change coupon status. 
    // Update coupon metadata.
    // set Used = true.
    // set invoiceURL - ipfs CID json with purchase
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
}