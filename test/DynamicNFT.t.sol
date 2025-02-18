// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DynamicNFT} from "../src/DynamicNFT.sol";
import "@openzeppelin/token/ERC721/IERC721Receiver.sol";

contract DynamicNFTTest is Test, IERC721Receiver {
    uint256 private constant HEX_COLOR_LENGTH = 7; // # + 6 char
    DynamicNFT public dynamicNFT;
    address public owner;
    
    function setUp() public {
        dynamicNFT = new DynamicNFT();
        owner = address(this);
    }

    function testGenerateHexColorWithCorrectLengthFromAddress() public view {
        string memory color = dynamicNFT.generateColorFromAddress(owner);
        assert(bytes(color).length == HEX_COLOR_LENGTH);
    }

    function testMint() public {
        vm.prank(owner);
        dynamicNFT.mint(owner);
        assert(dynamicNFT.ownerOf(0) == owner);
    }

    /** this might be an invalid test in a huge pool of addresses (fuzz testing) 
        because the total number of possible hexcolor is 16,777,216 colors only
        while there are 2^160 possible addresses,
        so some addresses are bound to have a same colors eventually
    */
    function testMintDifferentColorWith2Addresses() public {
        address firstOwner = address(0x123);
        address secondOwner = address(0x456);

        vm.startPrank(owner);
        
        dynamicNFT.mint(firstOwner);
        string memory firstSVG = dynamicNFT.tokenURI(0);

        dynamicNFT.mint(secondOwner);
        string memory secondSVG = dynamicNFT.tokenURI(1);
    
        vm.stopPrank();

        assert(keccak256(abi.encodePacked(firstSVG)) != keccak256(abi.encodePacked(secondSVG)));
    }

    function testMintSameColorWithSameAddress() public {
        address sameOwner = address(0x123);

        vm.startPrank(owner);
        
        dynamicNFT.mint(sameOwner);
        string memory firstSVG = dynamicNFT.tokenURI(0);

        dynamicNFT.mint(sameOwner);
        string memory secondSVG = dynamicNFT.tokenURI(1);
    
        vm.stopPrank();

        assert(keccak256(abi.encodePacked(firstSVG)) == keccak256(abi.encodePacked(secondSVG)));
    }

    // this function is override functions required by IERC721Receiver
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}
