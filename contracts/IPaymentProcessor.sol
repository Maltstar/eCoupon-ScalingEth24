pragma solidity ^0.8.24;

// 1. Accept ERC20.
// 2. Accept coupon.
// 3. Verify coupon.
// 4. Change coupon status. 
    // Update coupon metadata.
    // set Used = true.
    // set invoiceURL - ipfs CID json with purchase

interface IPaymentProcessor {
  function useCoupon(uint256 couponCollectionID, uint couponID) external;
  function acceptPayment(address token, uint256 amount, bytes memory couponData) external;
  function setInvoiceURL(uint256 couponCollectionID, uint couponID, string memory invoiceURL) external;
}