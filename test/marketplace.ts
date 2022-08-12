import { expect } from "chai";
import { ethers } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import { time } from "console";
import { mineBlocks, expandTo18Decimals } from "./utilities/utilities";
import {
  Marketplace__factory,
  Marketplace,
  MyNFT,
  MyNFT__factory,
  NFTToken,
  NFTToken__factory
} from "../typechain-types";
import { execPath } from "process";
import { Address } from "cluster";

describe("Testing", function() {
  let marketplace: Marketplace;
  let nft: MyNFT;
  let token : NFTToken;
  let owner: SignerWithAddress;
  let signers: SignerWithAddress[];

  beforeEach("", async () => {
    signers = await ethers.getSigners();
    owner = signers[0];
    token = await new NFTToken__factory(owner).deploy();  
    nft = await new MyNFT__factory(owner).deploy("keshav","knft");
    marketplace= await new Marketplace__factory(owner).deploy(nft.address,token.address);
    await nft.connect(owner).transferOwnership(marketplace.address);
    // console.log(nft.address);
  })
 
  describe("listing of single nft", async()=>{
    it("listing for first time", async()=>{
      await marketplace.connect(signers[2]).listing("first",100);
      let tokenid1 = await marketplace.NftId("second");
      expect(tokenid1).to.be.eq(0);
      let owner1 = (await marketplace.Nftstatus(tokenid1)).owner
      expect(owner1).to.be.eq(signers[2].address);
      let sold = (await marketplace.Nftstatus(tokenid1)).sold;
      expect(sold).to.be.eq(false);
      let price1 = (await marketplace.Nftstatus(tokenid1)).price;
      expect(price1).to.be.eq(100);
      await marketplace.connect(signers[3]).listing("second",200);
      let tokenid2 = await marketplace.NftId("second");
      expect(tokenid2).to.be.eq(1);
      let owner2 = (await marketplace.Nftstatus(tokenid2)).owner
      expect(owner2).to.be.eq(signers[3].address);
      let sold2 = (await marketplace.Nftstatus(tokenid2)).sold;
      expect(sold2).to.be.eq(false);
      let price2 = (await marketplace.Nftstatus(tokenid2)).price;
      expect(price2).to.be.eq(200);
      let totalnftlisted = await marketplace.totalNFTlisted();
      expect(totalnftlisted).to.be.eq(2);
      
      
    })
  })
  describe("multiple listing ", async()=>{
    it("listing mulltiple nfts", async()=>{
     await marketplace.connect(signers[5]).multilisting(["abc","zyz","gef"],[100,200,300]);
     
    })
  })

  describe("buy", async()=>{
    it("buying one at one time", async()=>{
    
    await marketplace.connect(signers[2]).listing("abc",100);
    
    await token.connect(signers[3]).mint(expandTo18Decimals(100));
    
    await token.connect(signers[3]).approve(marketplace.address,expandTo18Decimals(100));
  
    
    
    await marketplace.connect(signers[3]).buy(0);
    let balanceoftoken = await token.balanceOf(signers[2].address);
    expect(balanceoftoken).to.be.eq(expandTo18Decimals(100));
    
    
    })
  })

describe("buy multiple nfts", async()=>{
  it("buy multiplnfts", async()=>{

    await marketplace.connect(signers[2]).listing("abc",100);
    await marketplace.connect(signers[3]).listing("abc",100);
    await marketplace.connect(signers[4]).listing("abc",100);
    await token.connect(signers[5]).mint(expandTo18Decimals(300));
    await token.connect(signers[5]).approve(marketplace.address,expandTo18Decimals(300));
    await marketplace.connect(signers[5]).buymultipleNFTs([0,1,2]);

  })
})
  

})

console.log("Awesome !!!!")
