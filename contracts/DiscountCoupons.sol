// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

// 9. Register ERC20 token at 0 ID as fungible (ERC20) token that we will use as payment token.
// 10. Use coupon -> send to 0 address.

// Second contract - Payment processor + Coupon Execution
// 1. Accept ERC20.
// 2. Accept coupon.
// 3. Verify coupon.
// 4. Change coupon status. 
    // Update coupon metadata.
    // set Used = true.
    // set invoiceURL - ipfs CID json with purchase
// 7. User use coupon to get discount.

contract DiscountCoupons is ERC1155, Ownable, ERC1155Burnable, ERC1155Supply {
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
        uint256 discount;
        uint maxSupply;
        uint expirationDate;
    }

    mapping(uint couponCollectionID => CouponCollectionData) public couponCollections;
    uint public couponCollectionIDCounter;

    event CouponListed(address indexed couponListOwner, uint indexed vendorID, uint indexed couponCollectionID);
    event CouponUpdated(uint indexed couponCollectionID);
    event CouponMinted(address indexed couponOwner, uint indexed couponCollectionID, uint amount);
        
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
        uint256 discount, 
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
        couponCollections[couponID] = CouponCollectionData(vendorID, couponName, discount, maxCouponSupply, expirationDate);
        vendorCouponCollections[vendorID].push(couponID);

        // emit event
        emit CouponListed(msg.sender, vendorID, couponID);
        return couponID;
    }

    function updateCouponCollection(uint256 couponCollectionID, string memory name, uint256 discount, uint maxCouponAmount, uint expirationDate) external {
        require(vendors[couponCollections[couponCollectionID].vendorID].vendorAddress == msg.sender, "Only vendor can update its coupon collection");

        couponCollections[couponCollectionID].name = name;
        couponCollections[couponCollectionID].discount = discount;
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
        emit CouponMinted(msg.sender, couponCollectionID, amount);
    }

    // function to get available coupons amount to mint
    function availableCouponSupply(uint couponCollectionID) public view returns(uint) {
        uint maxSupply = couponCollections[couponCollectionID].maxSupply;
        uint totalSupply = totalSupply(couponCollectionID);
        return maxSupply - totalSupply;
    }

    // Tested above

    // TODO
    // function to usecoupon
    // add it to interface
    // burn the coupon & don't update total supply
    
    // The following functions are overrides required by Solidity.
    function _update(address from, address to, uint256[] memory ids, uint256[] memory values) internal override(ERC1155Supply, ERC1155) {
        super._update(from, to, ids, values);
    }
}
