// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

interface IERC1155eCoupon {
    function useCoupon(address couponOwner, uint256[] memory couponCollectionIds, uint256[] memory values, uint discountValue) external;
    function balanceOf(address account, uint256 id) external view returns (uint256);
    function getDiscountPercent(uint256 couponID) external view returns (uint256);

    event CouponUsed(uint indexed couponCollectionID, address indexed couponOwner, uint amount);
}
