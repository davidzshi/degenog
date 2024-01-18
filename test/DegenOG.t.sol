// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/DegenOG.sol";
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
    