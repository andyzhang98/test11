// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract CrowdFund {
    address public immutable beneficiary;
    uint256 public immutable fundingGoal;
    uint256 public fundAmount;
    mapping(address => uint256) public funders;

    mapping(address => bool) private fundersInserted;

    address[] public fundersKey;

    bool public AVALIABLE = true;

    constructor(address beneficiary_, uint256 goal_) {
        beneficiary = beneficiary_;
        fundingGoal = goal_;
    }

    function contribute() external payable {
        require(AVALIABLE, "contract is closed!");
        uint256 potentialFundingAmount = fundAmount + msg.value;

        uint256 refundAmount = 0;
        if (potentialFundingAmount > fundingGoal) {
            refundAmount = potentialFundingAmount - fundingGoal;
            funders[msg.sender] += (msg.value - refundAmount);
            fundAmount += (msg.value - refundAmount);
        } else {
            funders[msg.sender] += msg.value;
            fundAmount += msg.value;
        }

        if (!fundersInserted[msg.sender]) {
            fundersInserted[msg.sender] = true;
            fundersKey.push(msg.sender);
        }

        if (refundAmount > 0) {
            payable(msg.sender).transfer(refundAmount);
        }
    }

    function close() external returns (bool) {
        if (fundAmount < fundingGoal) {
            return false;
        }
        uint256 amount = fundAmount;
        fundAmount = 0;
        AVALIABLE = false;
        payable(beneficiary).transfer(amount);
        return true;
    }

    function funersLength() public view returns (uint256) {
        return fundersKey.length;
    }
}
