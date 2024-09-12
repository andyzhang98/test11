// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract MultiSignature{
    event ExecutionSuccess(bytes32 txHas);
    event ExecutionFailure(bytes32 txHas);
    address[] public  owners;
    mapping(address => bool) public  isOwner;
    uint256 public  ownerCount;
    uint256 public  threshold;
    uint256 public  nonce;

    receive() external payable { }

    constructor(address[] memory _owners,uint256 _threshod) payable {
        setOwners(_owners,_threshod);
    }
    function setOwners(address[] memory _owners,uint256 _threshod) internal  {
        require(threshold == 0,"RCC500");
        require(_threshod <= _owners.length,"RCC501");
        require(_threshod >= 1,"RCC502");
        for(uint256 i=0; i<_owners.length; i++){
            address owner =_owners[i];
            require(owner != address(0) && owner != address(this) && !isOwner[owner]);
            owners.push(owner);
            isOwner[owner] = true;
        }
        threshold = _threshod;
        ownerCount = owners.length;
    }
    function execTransaction(address to, uint256 value, bytes memory data, bytes memory signature) public payable virtual  returns(bool success) {
        bytes32 txHash = encodeTransactionData(to,value,data,nonce,block.chainid);
        nonce++;
        checkSignature(txHash, signature);
        (success,) = to.call{value:value}(data);
        require(success,"RCC5004");
        if(success) emit  ExecutionSuccess(txHash);
        else emit  ExecutionFailure(txHash);
    }

    function checkSignature(bytes32 txHash,bytes memory signature) internal  view {
        uint256 _threshold = threshold;
        require(_threshold > 0,"RCC5005");
        require(signature.length >= _threshold * 65,"RCC5007");
        address currentOwner;
        address lastOwner =address(0);
        uint8 v;
        bytes32 r;
        bytes32 s;
        for(uint256 i =0; i< _threshold;i++){
            (v,r,s) = splitSignature(signature,i);
            currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32",txHash)),v,r,s);
            require(currentOwner > lastOwner && isOwner[currentOwner],"RCC5008");
            lastOwner = currentOwner;
        }
    }
    function splitSignature(bytes memory _signature, uint256 i) internal  pure returns (uint8 v, bytes32 r, bytes32 s){
        assembly{
            let pos := mul(0x41, i)
            r := mload(add(_signature,add(pos,0x20)))
            s := mload(add(_signature,add(pos,0x40)))
            v := and(mload(add(_signature,add(pos,0x41))),0xff)
        }
    }

    function encodeTransactionData(address to, uint256 value, bytes memory data, uint256 _nonce, uint256 chainId) public  pure returns (bytes32){
        bytes32 safeTxHash = keccak256(abi.encode(to,value,keccak256(data),_nonce,chainId));
        return  safeTxHash;
    }

}