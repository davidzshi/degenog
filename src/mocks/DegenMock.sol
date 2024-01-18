// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract DegenTokenMock is ERC20 {
    uint256 public constant INITIAL_SUPPLY = 10000000000 * (10**18);

    constructor() ERC20("DegenMock", "DEGEN") {
        // Mint the initial supply of tokens to the deployer of the contract
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function burn(address account, uint256 amount) public {
        _burn(account, amount);
    }
}