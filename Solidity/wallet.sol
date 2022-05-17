// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.14;

contract cryptoCoin {

    // variables
    address public creator;

    // Mapping
    // CoinID => address
    mapping(uint256 => address) public coinOwner;
    
    // Address => Total Coins
    mapping(address => uint256) public ownedCoinsBalance;

    //Events
    event sent(address from, address to, uint256 coinID);

    constructor() {
        creator = msg.sender;
    }

    function _exists(uint256 coinID) public view returns(bool) {
        address owner = coinOwner[coinID];
        return owner != address(0);
    }

    function mint(uint256 coinID) public {
        require(!_exists(coinID), "Error: Coin exist");
        require(msg.sender == creator);

        coinOwner[coinID] = msg.sender;
        ownedCoinsBalance[msg.sender] += 1;
    }

    function _ownerOf(uint256 coinID) internal view returns(address) {
        address owner = coinOwner[coinID];
        require(owner != address(0), "Error: Invalid Coin");
        return owner;
    }

    function send(address receiver, uint256 coinID) public {
        require(_ownerOf(coinID) == msg.sender);
        require(receiver != address(0), "Error: Invalid Receiver");

        coinOwner[coinID] = receiver;
        ownedCoinsBalance[receiver] += 1;
        ownedCoinsBalance[msg.sender] -= 1;

        emit sent(msg.sender, receiver, coinID);
    }
}