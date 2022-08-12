// SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface INFT {

function mint(address user,string memory _tokenURI) external;


}