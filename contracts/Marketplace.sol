// SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.0;

import "./INFT.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";
contract Marketplace  {

    INFT public nft;
    IERC20 public itoken;
    constructor(address _NFTcontract, address _nfttoken)
    {
     nft = INFT(_NFTcontract);
     itoken = IERC20(_nfttoken);

    }
    
    uint totalNftsold;
    uint public tokenID;
    mapping(string =>uint) public tokenIDofthisURI;
    mapping(uint=>string) public  tokenURIforthisID;

    struct NFTdetail
    {
      bool sold;
      address owner;
      uint price;
      string tokenURI;
    }
    mapping(uint=>NFTdetail) public Nftstatus;
   
    
    function NftId(string memory _tokenURI) external view returns(uint)
    {
     return tokenIDofthisURI[_tokenURI];
    }

    function NftUri(uint _tokenID) external view returns(string memory)
    {
        return tokenURIforthisID[_tokenID];
    }
    
   
    function listing(string memory _tokenURI, uint _price) external 
    {
        tokenIDofthisURI[_tokenURI]= tokenID;
        tokenURIforthisID[tokenID]= _tokenURI;
        NFTdetail storage nftdetail = Nftstatus[tokenID];
        nftdetail.owner = msg.sender;
        nftdetail.price = _price;
        nftdetail.tokenURI = _tokenURI;
        tokenID++;
        
    }

  
    function multilisting(string[] memory _tokenURIs, uint[]  memory _prices) public 
    { 
     require(_tokenURIs.length== _prices.length,"prices of some URIs missing"); 
     

     for(uint i =0;i<_tokenURIs.length; i++)
      {   
      
       NFTdetail storage nftdetail = Nftstatus[tokenID];
       tokenIDofthisURI[_tokenURIs[i]]= tokenID;
    
       tokenURIforthisID[tokenID]= _tokenURIs[i];
       
       nftdetail.owner = msg.sender;
       
       nftdetail.price = _prices[i];
       nftdetail.tokenURI = _tokenURIs[i];
       
       tokenID++;
       
      }
      
        
    }

    function totalNFTlisted() external view returns(uint)
    {
        return tokenID;
    }

    function totalNFTsold() external view returns(uint)
    {
       return totalNftsold;
    }
   

    function buy(uint _tokenID) public // transferownership in nftcontract to marketplace 
    {    
         NFTdetail storage nftdetail = Nftstatus[_tokenID];
         
        require(nftdetail.sold==false,"This item is already sold");

        nft.mint(msg.sender,tokenURIforthisID[_tokenID]);

        itoken.transferFrom(msg.sender, nftdetail.owner, nftdetail.price*10**18);

        nftdetail.sold=true;
        
        nftdetail.owner = msg.sender;
    
        totalNftsold++;
        
    }
    
   
    function buymultipleNFTs(uint[] memory _tokenIDs) public// transferownership in nftcontract to marketplace 
    {   
        for(uint i= 0;i<_tokenIDs.length; i++)
        {
            NFTdetail storage nftdetail = Nftstatus[_tokenIDs[i]];
            require(nftdetail.sold==false,"some nft items");
           nft.mint(msg.sender,tokenURIforthisID[_tokenIDs[i]]);
           itoken.transferFrom(msg.sender, nftdetail.owner,nftdetail.price*10**18);
           nftdetail.sold=true;
           nftdetail.owner= msg.sender;
           totalNftsold++;
        }
    }

}