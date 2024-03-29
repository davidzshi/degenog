// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "lib/solmate/src/tokens/ERC721.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

error MintPriceNotPaid();
error MaxSupply();
error WithdrawTransfer();
error InsufficientDEGENBalance();
error NFTAlreadyMinted();

contract DegenOG is ERC721, Ownable {
    event Minted(address indexed recipient, uint256 tokenId);

    string public baseURI;
    uint256 public currentTokenId;
    uint256 public constant TOTAL_SUPPLY = 777;
    uint256 public constant MINT_PRICE = 0.00111 ether;

    IERC20 public degenToken;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseURI,
        address _degenTokenAddress
    ) ERC721(_name, _symbol) Ownable(msg.sender){
        baseURI = _baseURI;
        degenToken = IERC20(_degenTokenAddress);
    }

    mapping(address => uint256) public mintedCount;

    function mintTo(address recipient) external payable returns (uint256) {
        if (recipient == address(0)) revert("Recipient cannot be zero address");
        if (msg.value < MINT_PRICE) revert MintPriceNotPaid();

        uint256 degenBalance = degenToken.balanceOf(msg.sender);
        if (degenBalance < 1e6 * 10**18 || degenBalance == 0) revert InsufficientDEGENBalance();
        if (mintedCount[msg.sender] > 0) revert NFTAlreadyMinted();

        uint256 newTokenId = ++currentTokenId;
        if (newTokenId > TOTAL_SUPPLY) revert MaxSupply();

        _safeMint(recipient, newTokenId);

        // Increment the mintedCount after a successful mint
        mintedCount[msg.sender] += 1;

        emit Minted(recipient, newTokenId);

        return newTokenId;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        //  Use ownerOf to ensure the token has been minted, it will revert if not
        ownerOf(tokenId); // This will revert with "NOT_MINTED" if the token does not exist
        return baseURI; // Return the common base URI for all tokens
    }

    function withdrawPayments(address payable payee) external onlyOwner {
    if (payee == address(0)) revert("Payee cannot be zero address");

    uint256 balance = address(this).balance;
    payee.transfer(balance);
    }

}
