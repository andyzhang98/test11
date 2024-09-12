// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC165.sol";

interface IERC721 is IERC165{
    event Transfer(address indexed  from, address indexed  to, uint256 tokenId);

    event Approval(address indexed  owner, address indexed approved, uint256 tokenId);

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owener) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external  view returns (address operator);

    function safeTransferFrom(address from ,address to, uint256 tokenId, bytes calldata data)external ;

    function safeTransferFrom(address from ,address to, uint256 tokenId)external ;

    function transferFrom(address from ,address to, uint256 tokenId) external ;
    
    function approve(address to, uint256 tokenId)external ;
    
    function setApproval(address operator, bool _approved) external ;

    function setApprovalForAll(address operator, bool _approved) external ;

    function getApproved(uint256 tokenId) external  view returns (address operator);

    function isApprovedForAll(uint256 tokenId) external  view returns (address operator);
    
}