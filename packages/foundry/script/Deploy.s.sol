//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/ERC20mockup.sol";
import "../contracts/ERC1155eCoupon.sol";
import "../contracts/PaymentProcessor.sol";
import "./DeployHelpers.s.sol";

contract DeployScript is ScaffoldETHDeploy {
    error InvalidPrivateKey(string);

    function run() external {
        uint256 deployerPrivateKey = setupLocalhostEnv();
        if (deployerPrivateKey == 0) {
            revert InvalidPrivateKey(
                "You don't have a deployer account. Make sure you have set DEPLOYER_PRIVATE_KEY in .env or use `yarn generate` to generate a new random account"
            );
        }
        vm.startBroadcast(deployerPrivateKey);
        ERC20mockup erc20Contract =
            new ERC20mockup();
        console.logString(
            string.concat(
                "ERC20mockup deployed at: ", vm.toString(address(erc20Contract))
            )
        );
        
        ERC1155eCoupon eCouponContract =
            new ERC1155eCoupon();
        console.logString(
            string.concat(
                "ERC1155eCoupon deployed at: ", vm.toString(address(eCouponContract))
            )
        );
        
        PaymentProcessor paymentProcessor =
            new PaymentProcessor(
                address(eCouponContract),
                address(erc20Contract)
            );
        console.logString(
            string.concat(
                "PaymentProcessor deployed at: ", vm.toString(address(paymentProcessor))
            )
        );

        // ERROR
        // Doesnt work for some reason
        // eCouponContract.transferOwnership(address(paymentProcessor));
        
        vm.stopBroadcast();

        /**
         * This function generates the file containing the contracts Abi definitions.
         * These definitions are used to derive the types needed in the custom scaffold-eth hooks, for example.
         * This function should be called last.
         */
        exportDeployments();
    }

    function test() public {}
}
