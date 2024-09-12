// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract BTCToken{
    string private _name;
    string private _symbol;
    uint256 private  _totalSupply;
    mapping(address => uint256) private _balances;
    mapping (address => mapping(address => uint256)) private _allowances;
    address public  owner;

    event Transfer(address indexed  from, address indexed  to, uint256 value);

    event Approval(address indexed  owner, address indexed spender, uint256 value);
    
    constructor() public {
        _name = "Bitcoin";
        _symbol = "BTC";
        owner = msg.sender;
    }
    modifier onlyOwner{
        require(msg.sender == owner, "not owner");
        _;
    }
    function name() public  view returns (string memory) {
        return  _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public  view returns (uint256) {
        return  18;
    }

    function totalSupply() public  view returns (uint256){
        return  totalSupply();
    }

    function balanceOf(address acccount) public  view returns (uint256) {
        return  _balances[acccount];
    }

    function allowance(address _owner, address spender) public view returns(uint256) {
        return _allowances[_owner][spender];
    } 

    function approve(address spender, uint256 amount) public {
        _allowances[msg.sender][spender] +=amount;
        emit Approval(msg.sender, spender, amount);
    }
    function transfer(address to ,uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "insufficient balance");
        _balances[msg.sender] -= amount;
        _balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    function TransferFrom(address from , address to ,uint256 amount) public {
        uint256 _allwance = _allowances[from][msg.sender];
        require(_allwance >= amount, "allowance exceeded");
        require(_balances[msg.sender] >= amount,"insufficient balance");
        _balances[msg.sender] -= amount;
        _balances[to] += amount;
        _allowances[from][msg.sender] -= amount;
        emit  Transfer(from, to, amount);
    }

    function mint(address account, uint256 amount) public onlyOwner {
        _balances[account] += amount;
        _totalSupply += amount;
        emit Transfer(address(0), account, amount);
    }

    function burn(address account, uint256 amount) public  onlyOwner{
        require(_balances[account]>= amount, "insufficient balance to burn");
        _balances[account] -= amount;
        _totalSupply -= amount;
        emit Transfer(address(0), account, amount);
    }
}