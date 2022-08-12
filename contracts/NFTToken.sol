// SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
//import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "hardhat/console.sol";

contract NFTToken is ERC20
{
    constructor() ERC20("NFTToken","NFK"){}

    function mint(uint _amount) external 
    {
        _mint(msg.sender, _amount);
    }

    function burn( uint _amount) external
    {
        _burn(msg.sender,_amount);
    }
}

