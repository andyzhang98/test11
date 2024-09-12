// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./IERC165.sol";
import "./IERC721.sol";
import "./IERC721Receiver.sol";
import "./IERC721Metadata.sol";
import "./String.sol";



contract ERC721 is IERC721,IERC721Metadata{
    using  Strings for uint256;

    string public override  name;

    string public  override  symbol;

    mapping(uint => address) public  _owners;

    mapping(address => uint ) private  _balances;

    mapping(uint => address) private  _tokenApprovals;

    mapping(address => mapping(address => bool)) private _operatorApprovals;

    error ERC721InvalidReceiver(address receiver);


    constructor(string memory name_, string memory symbol_){
        name=name_;
        symbol=symbol_;
    }

    function supportsInterface(bytes4 interfaceId) external pure override  returns (bool){
        return interfaceId == type(IERC721).interfaceId ||
        interfaceId ==type(IERC165).interfaceId ||
        interfaceId == type(IERC721Metadata).interfaceId;
    }

    function balanceOf(address owner) external view override returns (uint256 balance){
        require(owner != address(0),"owner= zero address");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public   view override  returns (address owner){
        owner = _owners[tokenId];
        require(owner != address(0),"token does't exist");
    }

    function isApprovalForAll(address owner, address operator) external  view override  returns (bool){
        return _operatorApprovals[owner][operator];
    }
    
    function setApprovalForAll(address operator,bool approved) external   override {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender,operator,approved);
    }

    function getApproved(uint256 tokenId) external  view override  returns (address){
        require(_owners[tokenId] != address(0),"token doesn;t exist");
        return _tokenApprovals[tokenId];
    }
    function _approve(address owner, address to, uint tokenId) private {
        _tokenApprovals[tokenId] = to;
        emit Approval(owner,to,tokenId);
    }

    function approve(address to, uint tokenId) external   override{
        address owner = _owners[tokenId];
        require(owner == msg.sender || _operatorApprovals[owner][msg.sender],"not owner nor approved for all");
        _approve(owner,to,tokenId);
    }
    
    function isApprovedOrOwner(address owner, address spender, uint tokenId) private  view returns (bool){
        return (owner == spender || _tokenApprovals[tokenId]==spender || _operatorApprovals[owner][spender]);
    }

    function _transfer(address owner ,address from, address to, uint tokenId) private {
        require(from == owner,"not owenr");

        require(to != address(0),"transfer to zero address");

        _approve(owner, address(0), tokenId);

        _balances[owner] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit  Transfer(from,to,tokenId);
    }

    function transferFrom(address from ,address to, uint tokenId) external  override {
        address owner= _owners[tokenId];
        require(isApprovedOrOwner(owner,from,tokenId),"not owner nor approved");
        _transfer(owner,from,to,tokenId);
    }

    function _safeTransfer(address owner, address from ,address to, uint tokenId, bytes memory _data) private {
        _transfer(owner,from ,to,tokenId);
        _checkeOnERC721Received(from,to,tokenId,_data);
    }

    function safeTransferFrom(address from ,address to ,uint tokenId, bytes memory  _data) public  override {
        address owner = _owners[tokenId];
        require(isApprovedOrOwner(owner,msg.sender,tokenId));
        _safeTransfer(owner,from,to,tokenId,_data);
    }
    function safeTransferFrom(
        address from,
        address to,
        uint tokenId
    ) external override {
        safeTransferFrom(from, to, tokenId, "");
    }
    function _mint(address to, uint tokenId) internal virtual {
        require(to != address(0), "mint to zero address");
        require(_owners[tokenId] == address(0), "token already minted");

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    function _burn(uint tokenId) internal virtual {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner, "not owner of token");

        _approve(owner, address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }


    function _checkeOnERC721Received(address from ,address to, uint tokenId, bytes memory data) private {
        if(to.code.length>0){
            try IERC721Receiver(to).onERC721Received(msg.sender,from,tokenId,data) returns (bytes4 retval){
                if(retval != IERC721Receiver(to).onERC721Received.selector){
                    revert ERC721InvalidReceiver(to);
                }
            }
            catch (bytes memory reason){
                if(reason.length ==  0){
                    revert ERC721InvalidReceiver(to);
                }
                else {
                    assembly{
                        revert(add(32,reason),mload(reason))
                    }
                }
            }
        }
    }

    function tokenURI(uint256 tokenId) public view virtual override  returns (string memory) {
        require(_owners[tokenId] !=address(0),"token not exist");

        string memory baseURI =_baseURI();
        return bytes(baseURI).length >0 ? string(abi.encodePacked(baseURI,tokenId.toString())):"";
    }

    function _baseURI() internal  view  virtual   returns (string memory) {
        return  "";
    }

    


    
}