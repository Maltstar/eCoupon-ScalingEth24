// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

interface IERC1155eCoupon {
    function useCoupon(address couponOwner, uint256[] memory couponCollectionIds, uint256[] memory values) external;

    event CouponUsed(uint indexed couponCollectionID, address indexed couponOwner, uint amount);
}
