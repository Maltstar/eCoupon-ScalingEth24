// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

// 10. Use coupon -> send to 0 address.
// 11. set URI for token image.
// 12. Implement receiver/holder.

contract ERC1155eCoupon is ERC1155, Ownable, ERC1155Burnable, ERC1155Supply {
    constructor() ERC1155("") Ownable(msg.sender) {}

    // Vendor sector
    struct Vendor {
        address vendorAddress;
        string name;
        string storeLink;
    }
    
    mapping(uint vendorID => Vendor) public vendors;
    mapping(uint vendorID => uint vendorBalance) public vendorBalance;
    mapping(uint vendorID => uint[] couponCollectionsByVendor) public vendorCouponCollections;
    mapping(address _address => uint vendorID) public _addressToVendorID;
    uint public vendorIDCounter = 0;

    event VendorRegistered(address indexed vendorAddress, uint vendorID);
    event VendorUpdated(uint indexedvendorID);

    // Coupons sector
    struct CouponCollectionData {
        uint vendorID;
        string name;
        uint256 discountPercent;
        uint maxSupply;
        uint expirationDate;
        uint invoiceID;
    }

    mapping(uint couponCollectionID => CouponCollectionData) public couponCollections;
    mapping(uint couponCollectionID => uint totalDiscounted) public totalDiscountedAmountByCouponCollection_;
    uint public couponCollectionIDCounter;

    event CouponListed(uint indexed couponCollectionID, address indexed couponListOwner, uint indexed vendorID);
    event CouponUpdated(uint indexed couponCollectionID);
    event CouponMinted(uint indexed couponCollectionID, address indexed couponOwner, uint amount);
    event CouponUsed(uint indexed couponCollectionID, address indexed couponOwner, uint discountValue);
        
    // Referral sector
    struct Referral {
        address referralAddress;
        string name;
    }
    
    mapping(uint referralID => Referral) public _referrals;
    mapping(uint referralID => uint referralBalance) public referralBalance;
    uint public referralIDCounter;

    // Referral events
    // TODO

    // Vendor functions
    function registerNewVendor(string memory name, string memory storeLink) public returns(uint) {
        // check that is not vendor
        require(isVendor(msg.sender) == false, "Already vendor");
        // get current vendor ID & start numeration from 1
        uint newVendorID = ++vendorIDCounter;
        // set new vendor structure
        vendors[newVendorID] = Vendor(msg.sender, name, storeLink);
        // update addressToVendorID mapping for isVendor function to work.
        _addressToVendorID[msg.sender] = newVendorID;
        // emit event
        emit VendorRegistered(msg.sender, newVendorID);
        return newVendorID ;
    }

    function updateVendor(uint vendorID, string memory name, string memory storeLink) public {
        require(vendors[vendorID].vendorAddress == msg.sender, "Only vendor can update its data");
        vendors[vendorID].name = name;
        vendors[vendorID].storeLink = storeLink;
        // emit event
        emit VendorUpdated(vendorID);
    }

    // internal function to check if the address registered as vendor
    function isVendor(address _address) internal view returns (bool) {
        return _addressToVendorID[_address] > 0;
    }

    function listCouponCollection(
        string memory vendorName, 
        string memory storeLink, 
        string memory couponName, 
        uint256 discountPercent, 
        uint maxCouponSupply, 
        uint expirationDate
    ) public returns(uint) {
        // get vendor ID
        uint vendorID = _addressToVendorID[msg.sender];
        // check if vendor already registered
        if (isVendor(msg.sender) == false) {
            vendorID = registerNewVendor(vendorName, storeLink);
        }
        
        // get & increment couponID
        uint couponID = ++couponCollectionIDCounter;
        couponCollections[couponID] = CouponCollectionData(vendorID, couponName, discountPercent, maxCouponSupply, expirationDate, 0);
        vendorCouponCollections[vendorID].push(couponID);

        // emit event
        emit CouponListed(couponID, msg.sender, vendorID);
        return couponID;
    }

    function updateCouponCollection(uint256 couponCollectionID, string memory name, uint256 discountPercent, uint maxCouponAmount, uint expirationDate) external {
        require(vendors[couponCollections[couponCollectionID].vendorID].vendorAddress == msg.sender, "Only vendor can update its coupon collection");

        couponCollections[couponCollectionID].name = name;
        couponCollections[couponCollectionID].discountPercent = discountPercent;
        couponCollections[couponCollectionID].maxSupply = maxCouponAmount;
        couponCollections[couponCollectionID].expirationDate = expirationDate;

        // emit event
        emit CouponUpdated(couponCollectionID);
    }

    function mintCoupon(uint256 couponCollectionID, uint amount) external {
        // check that max coup amount is not reached.
        uint availableSupply = availableCouponSupply(couponCollectionID);
        require(availableSupply >= amount, "Max coupon amount reached");

        _mint(msg.sender, couponCollectionID, amount, "");
        
        // emit event
        emit CouponMinted(couponCollectionID, msg.sender, amount);
    }

    // function to get available coupons amount to mint
    function availableCouponSupply(uint couponCollectionID) public view returns(uint) {
        uint maxSupply = couponCollections[couponCollectionID].maxSupply;
        uint totalSupply = totalSupply(couponCollectionID);
        return maxSupply - totalSupply;
    }

    // function to usecoupon
    function useCoupon(address couponOwner, uint256[] memory couponCollectionIds, uint256[] memory values, uint _discountValue) external onlyOwner {
        // require coupon owner have the coupon
        uint currentBalance = balanceOf(couponOwner, couponCollectionIds[0]);
        require(currentBalance >= values[0], "Not enough coupons on balance");
        // burn the coupon & don't update total supply
        // send coupon to this contract
        _update(couponOwner, address(this), couponCollectionIds, values);

        totalDiscountedAmountByCouponCollection_[couponCollectionIds[0]] += _discountValue;

        // event
        emit CouponUsed(couponCollectionIds[0], couponOwner, _discountValue);
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function getDiscountPercent(uint256 _couponID) public view returns (uint256) {
        return couponCollections[_couponID].discountPercent;
    }

    // funciton to get total discounted amount by coupon Id
    function getTotalDiscountedAmount(uint _couponID) public view returns (uint) {
        return totalDiscountedAmountByCouponCollection_[_couponID];
    }

    function getVendorAddress(uint _vendorID) public view returns(address) {
        return vendors[_vendorID].vendorAddress;
    }
    
    // The following functions are overrides required by Solidity.
    function _update(address from, address to, uint256[] memory ids, uint256[] memory values) internal override(ERC1155Supply, ERC1155) {
        super._update(from, to, ids, values);
    }
}