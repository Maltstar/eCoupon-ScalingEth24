// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract ERC20mockup is ERC20, ERC20Permit {
    constructor()
        ERC20("e-Coupon $ERC20 mockup", "$EDC")
        ERC20Permit("e-Coupon $ERC20 mockup")
    {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
