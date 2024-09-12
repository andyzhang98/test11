// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./ERC721.sol";

library ECDSA{
    function vertify(bytes32  _msgHash, bytes memory _signature,  address _signer) internal  pure returns (bool) {
        return recoverSigner(_msgHash,_signature) == _signer;
    }

    function recoverSigner(bytes32 _msgHash,bytes memory _signature) internal pure returns (address) {
        require(_signature.length == 65, "invalid length");
        bytes32 r;
        bytes32 s;
        uint8 v;
        assembly{
            r := mload(add(_signature,0x20))
            s := mload(add(_signature,0x40))
            v := byte(0,mload(add(_signature,0x60)))
        }
        return ecrecover(_msgHash, v, r, s);
    }

    function toEthSignature(bytes32 _msgHash) internal  pure returns (bytes32) {

        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32",_msgHash));
    }
}

contract Signature is ERC721{
    mapping(address => bool) public mintedAddress;

    address immutable public  signer;
    constructor(string memory _name,string memory _symbol,address _signer)ERC721(_name,_symbol){
        signer = _signer;
    }

    function mint(address _account, bytes memory _signature, uint256 tokenId) external {
        bytes32 _msgHash = getMessageHash(_account, tokenId);
        bytes32 _etheSignature = ECDSA.toEthSignature(_msgHash);
        require(_vertify(_etheSignature,_signature),"invalid signature");
        require(mintedAddress[_account],"already minted");
        mintedAddress[_account] = true;
        _mint(_account, tokenId);
        }
    function getMessageHash(address _account, uint256 tokenId) public  pure returns (bytes32){
        return keccak256(abi.encodePacked(_account,tokenId));
    }

    function _vertify(bytes32 _msgHash,bytes memory  _signature)public  view returns(bool){
        return ECDSA.vertify(_msgHash, _signature, signer);
    }
}