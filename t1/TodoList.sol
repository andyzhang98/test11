// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract TodoList {
    struct Todo {
        string name;
        bool isCompleted;
    }

    Todo[] public list;

    function create(string memory _name) external {
        list.push(Todo({name: _name, isCompleted: false}));
    }

    function modiName1(uint256 index_,string memory name_)external {
        list[index_].name=name_;
    }
    function modiName2(uint256 index_,string memory name_)external {
        Todo storage temp=list[index_];
        temp.name=name_;
    }

    function modiStatus(uint256 index_)external {
        list[index_].isCompleted=!list[index_].isCompleted;
    }

    function modiStatus1(uint256 index_,bool status)external  view{
        Todo memory temp=list[index_];
        temp.isCompleted= status;
    }
    function modiStatus2(uint256 index_)external {
        Todo storage temp=list[index_];
        temp.isCompleted=!temp.isCompleted;
    }
    function get1(uint256 index_)external view returns(string memory name ,bool status){
        Todo memory temp =list[index_];
        return (temp.name,temp.isCompleted);
    }
    function get2(uint256 index_)external  view returns (string memory name,bool status){
        Todo storage temp=list[index_];
        return (temp.name,temp.isCompleted);
    }
}
