// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/ERC1155eCoupon.sol";

contract ERC1155eCouponTest is Test {
    ERC1155eCoupon public eCoupon;

    function setUp() public {
        eCoupon = new ERC1155eCoupon();
    }
}
