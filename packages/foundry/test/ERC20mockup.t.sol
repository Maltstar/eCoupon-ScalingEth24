// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/ERC20mockup.sol";

contract ERC20mockupTest is Test {
    ERC20mockup public erc20mockup;

    function setUp() public {
        erc20mockup = new ERC20mockup();
    }
}
