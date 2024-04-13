// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

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

// Second contract - Payment processor + Coupon Execution
// 1. Accept ERC20.
// 2. Accept coupon.
// 3. Verify coupon.
// 4. Change coupon status. 
    // Update coupon metadata.
    // set Used = true.
    // set invoiceURL - ipfs CID json with purchase

contract DiscountCoupons is ERC1155, Ownable, ERC1155Burnable, ERC1155Supply {
    constructor(address initialOwner) ERC1155("") Ownable(initialOwner) {}

    mapping(uint256 couponCollectionID => uint256 maxCouponAmount) maxCouponAmounts;

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyOwner
    {
        // Check that next minted coupon doesnt exceed maxCouponAmounts.
        _mint(account, id, amount, data);
    }

    // 2. 
    // function updateCouponParameters(address account, uint256 id, uint256 amount, bytes memory data)
    //     public
    //     onlyOwner
    // {

    // }
    
    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }
}