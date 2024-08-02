// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ETH {
    address payable public immutable owner;
    event Log(string funName, address from, uint256 value, bytes data);

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {
        emit Log("recieve", msg.sender, msg.value, "");
    }

    function withdraw1() external {
        require(msg.sender == owner, "not owner!");
        // owner.transfer(address(this).balance); owners比msg.sender更消耗gas
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdraw2() external {
        require(msg.sender == owner, "not owner!");
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "call failed");
    }

    function withdraw3() external {
        require(msg.sender == owner, "not owner!");
        bool success = payable(msg.sender).send(200);
        require(success, "Send Failed");
    }
}
