// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";

interface IERC721 {
    function isApprovedForAll(address _owner, address _operator)
        external
        view
        returns (bool);

    function ownerOf(uint256 _tokenId) external view returns (address);

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable;

    function setApprovalForAll(address _operator, bool _approved) external;
}

contract TestERC721Operators is Test {
    // ERC721 contract to test against
    IERC721 nftContract;

    // Token ID to test against
    uint256 tokenId;

    // Owner of the NFT
    address owner;

    address[] VALID_OPERATORS = [
        // Seaport
        0x1E0049783F008A0085193E00003D00cd54003c71
    ];

    address[] INVALID_OPERATORS = [
        // X2Y2
        0xF849de01B080aDC3A814FaBE1E2087475cF2E354
    ];

    function setUp() public {
        // Load test data via environment variables
        nftContract = IERC721(vm.envAddress("CONTRACT_ADDRESS"));
        tokenId = vm.envUint("TOKEN_ID");

        // Fork mainnet
        vm.createSelectFork(vm.envString("ETH_RPC_URL"));

        // Get the current owner of the NFT
        owner = nftContract.ownerOf(tokenId);
    }

    function testValidOperators() public {
        for (uint256 i = 0; i < VALID_OPERATORS.length; i++) {
            // Test operator is not approved initially
            address operator = VALID_OPERATORS[i];
            assertFalse(nftContract.isApprovedForAll(owner, operator));

            // Set approval for the operator
            vm.prank(owner);
            nftContract.setApprovalForAll(operator, true);

            // Test operator is able to transfer the token
            vm.prank(operator);
            nftContract.safeTransferFrom(owner, address(1), tokenId);
            assertTrue(nftContract.ownerOf(tokenId) == address(1));
        }
    }

    function testInvalidOperators() public {
        for (uint256 i = 0; i < INVALID_OPERATORS.length; i++) {
            // Test operator is not approved initially
            address operator = INVALID_OPERATORS[i];
            assertFalse(nftContract.isApprovedForAll(owner, operator));

            // Set approval for the operator
            vm.prank(owner);
            nftContract.setApprovalForAll(operator, true);

            // Test operator is able to transfer the token
            vm.prank(operator);
            vm.expectRevert();
            nftContract.safeTransferFrom(owner, address(1), tokenId);
        }
    }
}
