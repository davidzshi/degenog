// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract DegenTokenMock is ERC20 {
    uint256 public constant INITIAL_SUPPLY = 10**24; // 1 million tokens, for example

    constructor() ERC20("DegenMock", "DEGENM") {
        // Mint the initial supply of tokens to the deployer of the contract
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
