import { ethers } from "hardhat";
const helpers = require("@nomicfoundation/hardhat-network-helpers");


async function main() {

  const BORED_APE_NFT_OWNER = "0x2c2ed4b3876c442fee80BeE76Ce0eE2CA2A512AF";
  const STAKING_AMOUNT = ethers.utils.parseEther("1");

  console.log("DEPOLYING TOKEN and CONTRACT")

  const Hydra = await ethers.getContractFactory("Token");
  const hydra = await Hydra.deploy();
  await hydra.deployed();

  const KVS = await ethers.getContractFactory("Token");
  const kvs = await KVS.deploy();
  await kvs.deployed();

  const Staking = await ethers.getContractFactory("Staking");
  const staking = await Staking.deploy(hydra.address, kvs.address);
  await staking.deployed();

  console.log("Transfering Tokens");
  
  await (await hydra.transfer(BORED_APE_NFT_OWNER, ethers.utils.parseEther("2000"))).wait();
  await (await kvs.transfer(staking.address, ethers.utils.parseEther("2000"))).wait();


  console.log("IMPERSONATING")

  await helpers.impersonateAccount(BORED_APE_NFT_OWNER);
  const impersonatedSigner = await ethers.getSigner(BORED_APE_NFT_OWNER);


  // console.log("SENDING")
  // let signer = await ethers.getSigners()
  // await signer[0].sendTransaction({
  //   to: BORED_APE_NFT_OWNER,
  //   value: ethers.utils.parseEther("1")
  // })
  console.log("STAKING")

  await (await hydra.connect(impersonatedSigner).approve(staking.address, STAKING_AMOUNT)).wait();
  await (await staking.connect(impersonatedSigner).stake(STAKING_AMOUNT)).wait();



  console.log("STAKING SUCESSFUL :)");
  
}



main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
