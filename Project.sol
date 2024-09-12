// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Project{

    enum  ProjectState{Ongoing, Successful, Failed}

    struct Donation{
        address donor;
        uint256 amount;
    }

    address public  creator;
    string public description;
    uint256 public goalAmount;
    uint256 public deadline;
    uint256 public currentAmount;
    ProjectState public  state;
    Donation[] public donations;

    event DonationReceived(address indexed  donor, uint256 amount);
    event ProjectStateChanged(ProjectState newState);
    event FundWithdraw(address indexed  creator, uint256 amount);
    event FundReFunded(address indexed donor, uint256 amount);

    modifier  OnlyCreator{
        require(msg.sender == creator, "not the project creator");
        _;
    }

    modifier  OnlyAfterDeadline{
        require(block.timestamp >= deadline,"Project still ongoing");
        _;
    }
    function initialize(address _creator, string memory _description, uint256 _goalAmount, uint256 _duaration) public {
        creator = _creator;
        description = _description;
        goalAmount = _goalAmount;
        deadline = block.timestamp + _duaration;
        state = ProjectState.Ongoing;


    }

    function donate() public payable {
        require(state == ProjectState.Ongoing,"Project is not Ongoing");
        require(block.timestamp <= deadline,"project deadline has passed");
        donations.push(Donation({
             donor : msg.sender,
            amount : msg.value
        }));
        currentAmount += msg.value;
        emit  DonationReceived(msg.sender, msg.value);
    }

    function withdrawFunds() external  OnlyCreator OnlyAfterDeadline{
        require(state == ProjectState.Successful , "project is not successful");
        uint256 amount =address(this).balance;
        payable(creator).transfer(amount);
        emit  FundWithdraw(creator, amount);
    }

    function refund() external OnlyAfterDeadline{
        require(state == ProjectState.Failed, "project not failed");
        uint256 refundAmount = 0;
        for(uint256 i = 0; i <donations.length;i++){
            if(donations[i].donor == msg.sender){
                refundAmount += donations[i].amount;
                donations[i].amount = 0;
            }
            require(refundAmount > 0, "No funds to refund");
            payable(msg.sender).transfer(refundAmount);
            emit  FundReFunded(msg.sender, refundAmount);
        }
    }
    function updateProjectState() external  OnlyAfterDeadline{
        require(state == ProjectState.Ongoing, "project is already fanalized");
        if(currentAmount >= goalAmount){
            state =ProjectState.Successful;
        }else {
            state = ProjectState.Failed;
        }

        emit  ProjectStateChanged(state);
    }
    
    
}