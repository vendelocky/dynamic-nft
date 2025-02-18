// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/access/Ownable.sol";
import "@openzeppelin/utils/Strings.sol";
import "@openzeppelin/token/ERC721/ERC721.sol";
import "@openzeppelin/utils/Base64.sol";

contract DynamicNFT is ERC721, ERC721URIStorage, Ownable {
    uint8 constant private ASCII_NUM_RANGE = 10; //0 - 9
    uint8 constant private ASCII_ZERO = 48; // 0
    uint8 constant private ASCII_A = 87; // a
    uint8 constant private HEX_LENGTH = 6; // hex color length
    uint8 constant private NIBBLE_DIVISOR = 16; // 0x10

    uint256 private _tokenId;

    event generatedColor(uint256 indexed tokenId, address owner, string color);

    constructor() ERC721("DynamicNFT", "DNFT") Ownable(msg.sender) {}

    function mint(address to) public onlyOwner {
        string memory color = generateColorFromAddress(to);
        emit generatedColor(_tokenId, to, color);

        _safeMint(to, _tokenId);
        _setTokenURI(_tokenId, _generateMetadata(color));
        _tokenId++;
    }

    function generateColorFromAddress(address owner) public pure returns (string memory) {
        bytes32 hash = keccak256(abi.encodePacked(owner));
        return string(abi.encodePacked("#", _toHexString(hash, HEX_LENGTH)));
    }

    function _toHexString(bytes32 hash, uint length) private pure returns (string memory) {
        // creating a new bytes array to store the hex characters [0,0,0,0,0,0]
        bytes memory str = new bytes(length);

        /**
         * each byte is converted to 2 hex characters, so we only need to iterate through half of the length to get 6 hex characters.
         * next we convert the hash (per iteration) to uint8 so it can be divided by another uint8.
         * each byteValue is divided by 16 to get the first hex character; and the remainder of the division is the second hex character.
         * use _byteToHexChar to convert the result to get the ASCII value of the hex character, because we need to show the hex color in string format, with the right ASCII value (0-9, a-f).
         * the first hex character is stored in the even index of the str array, and the second hex character is stored in the odd index.
         * iterate 3 times to get 6 hex characters.
         */
        for (uint i = 0; i < length / 2; i++) {
            uint8 byteValue = uint8(hash[i]);
            str[2 * i] = _byteToHexChar(byteValue / NIBBLE_DIVISOR);
            str[2 * i + 1] = _byteToHexChar(byteValue % NIBBLE_DIVISOR);
        }
        return string(str);
    }

    function _byteToHexChar(uint8 b) private pure returns (bytes1) {
        return b < ASCII_NUM_RANGE ? bytes1(b + ASCII_ZERO) : bytes1(b + ASCII_A);
    }

    function _generateMetadata(string memory color) private pure returns (string memory) {
        string memory svg = string(abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200">',
            '<rect width="200" height="200" fill="', color, '" />',
            '</svg>'
        ));

        // Encode the SVG as base64
        string memory base64Svg = _encodeBase64(bytes(svg));

        // Return the metadata URL pointing to the SVG
        return string(abi.encodePacked(
            "data:application/json;base64,", _encodeBase64(bytes(abi.encodePacked(
                '{"name":"DynamicNFT",',
                '"description":"This is your lucky color",',
                '"image":"data:image/svg+xml;base64,', base64Svg, '"}'
            )))
        ));
    }
    
    function _encodeBase64(bytes memory data) private pure returns (string memory) {
        return Base64.encode(data);
    }

    // following functions are override functions required

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
