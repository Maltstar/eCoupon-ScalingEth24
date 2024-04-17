// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PaymentProcessor is Ownable {
    IERC20 public token;
    
    constructor() Ownable(msg.sender) {}
    // functino to process payment. Inputs: sum, invoiceCID, vendorID, couponID

}

// Second contract - Payment processor + Coupon Execution
// 1. Accept ERC20.
// 2. Accept coupon.
// 3. Verify coupon.
// 4. Change coupon status. 
    // Update coupon metadata.
    // set Used = true.
    // set invoiceURL - ipfs CID json with purchase
// 7. User use coupon to get discount.


// Referals
// 1. Stuct - address, id, name -mrbeast
// 2. Balance
// 3. % referal cut - vendor set default value. % from 
// 3.A unique 
// + parameter for DiscountCoupon
// 4. When customer input promoCode
// + User input referralPromoID when mintcoupon.
// + describe that we want to have additional verification for claiming promocoded coupon.
// + or mint only by link.
// + SET LIMIT on promo code amount. First 500 users will get discount.
// + Vendor create unique coupon collection for MrBeast.
// + 
// 5. Coupon price is 0 for MVP.

// contract PaymentProcessor {

//   function useCoupon(uint256 couponCollectionID, uint couponID) external {

//   }

//   function acceptPayment(address token, uint256 amount, bytes memory couponData) external{

//   }

//   function setInvoiceURL(uint256 couponCollectionID, uint couponID, string memory invoiceURL) external{

//   }

//   // function that will prepare coupon array & will call use coupon
//     function applyDiscountCoupon(uint couponCollectionID, address couponOwner, uint amount) internal {
//         // Create an array to store the coupon IDs
//         uint256[] memory couponIDs = new uint256[](1);
//         couponIDs[0] = couponCollectionID;

//         // Create an array to store the coupon amount
//         uint256[] memory values = new uint256[](1);
//         values[0] = amount;

//         DiscountCoupons.useCoupon(couponOwner, couponIDs, values);
//     }
// }