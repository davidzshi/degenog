// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import "../src/DegenOG.sol";
import "forge-std/Test.sol";
import "../src/mocks/DegenMock.sol";


contract DegenOGTest is Test {
    DegenOG degenOG;
    DegenTokenMock degenToken;

    function setUp() public {
        degenToken = new DegenTokenMock();
        degenToken.mint(address(this), 1e6 * 10**18);
        degenOG = new DegenOG("DegenOG", "DOG", "https://example.com/", address(degenToken));
        degenOG.transferOwnership(address(this)); // Transfer ownership to the test contract
    }

    function testMint() public {
    uint256 initialBalance = degenOG.balanceOf(msg.sender);

    // Call the mintTo function with enough Ether
    degenOG.mintTo{value: degenOG.MINT_PRICE()}(msg.sender);

    // Assert that the balance of the msg.sender has increased by 1
    assertEq(degenOG.balanceOf(msg.sender), initialBalance + 1);
}

function testCannotMintTwice() public {
    // Mint the first token
    degenOG.mintTo{value: degenOG.MINT_PRICE()}(msg.sender);

    // Try to mint a second token
    bool success = try_degenOG_mintTo(msg.sender);

    // Assert that the second mint operation failed
    assertTrue(!success);
}

// Helper function to attempt to mint a new token and return whether it succeeded
function try_degenOG_mintTo(address recipient) internal returns (bool) {
    // We use a low-level call to catch the revert
    (bool success, ) = address(degenOG).call{value: degenOG.MINT_PRICE()}(
        abi.encodeWithSignature("mintTo(address)", recipient)
    );
    return success;
}

function testCannotMintAfterSendingAllDegenToZero() public {
    // Send all DegenTokenMock tokens to the 0 address
    degenToken.transfer(address(0), degenToken.balanceOf(address(this)));

    // Try to mint a new token
    bool success = try_degenOG_mintTo(msg.sender);

    // Assert that the mint operation failed
    assertTrue(!success);
}

// Helper function to attempt to mint a new token and return whether it succeeded
function try_degenOG_mintTo(address recipient) internal returns (bool) {
    // We use a low-level call to catch the revert
    (bool success, ) = address(degenOG).call{value: degenOG.MINT_PRICE()}(
        abi.encodeWithSignature("mintTo(address)", recipient)
    );
    return success;
}

}