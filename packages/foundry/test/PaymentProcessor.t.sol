// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/PaymentProcessor.sol";

contract PaymentProcessorTest is Test {
    PaymentProcessor public paymentProcessor;

    function setUp() public {
        paymentProcessor = new PaymentProcessor(address(0), address(0));
    }
}
