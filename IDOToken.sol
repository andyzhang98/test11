// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract IDOToken is ERC20("AXS TOKEN","AXS"), Ownable{
    uint256 public idoPrice = 0.1 * 10 * 18;

    uint256 public maxBuyAmount = 10 * 10 ** 18;

    address public usdAddress = 0x606D35e5962EC494EAaf8FE3028ce722523486D2;

    mapping(address => bool) private  isBuy;

    constructor(address initalizor) Ownable(initalizor){}


    function buyToken(uint256  amount) public {
        require(!isBuy[msg.sender],"you has already bought!");

        require(amount <= maxBuyAmount, "invalid amount");

        IERC20(usdAddress).transferFrom(msg.sender, address(this), amount);
        
        uint256 buyNum = amount / idoPrice * 10 * 18;

        isBuy[msg.sender] = true;

        _mint(msg.sender,buyNum);
    }
    function withdraw() public  onlyOwner{
        uint256 bal = IERC20(usdAddress).balanceOf(address(this));

        IERC20(usdAddress).transfer(msg.sender,bal);
    }
}