// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {DynamicNFT} from "../src/DynamicNFT.sol";

contract DynamicNFTScript is Script {
    DynamicNFT public dynamicNFT;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        dynamicNFT = new DynamicNFT();

        vm.stopBroadcast();
    }
}
