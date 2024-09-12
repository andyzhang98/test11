// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC165.sol";

interface IERC721 is IERC165 {
    //记录转账事件
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    //授权事件
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    //批量授权
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    //获取钱包金额
    function balanceOf(address owner) external view returns (uint256 balance);

    //获取代币的所有者
    function ownerOf(uint256 tokenId) external  view returns (address owner);

     function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    //安全转账 携带data
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
    //安全转账 不携带data
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    //授权
    function approve(address to, uint256 tokenId) external ;
    //批量授权
    function setApprovalForAll(address operator, bool _approved) external;
    //查询是否被授权
    function getApproved(uint256 tokenId)external view returns (address operator);
    //批量查询是否被授权
    function isApprovalForAll(address owner, address operator) external  returns (bool _approved);
    }