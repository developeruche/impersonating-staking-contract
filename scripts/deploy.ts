import { ethers } from "hardhat";

async function main() {

  const BORED_APE_NFT_OWNER = "0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D";
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
  
  hydra.transfer(BORED_APE_NFT_OWNER, ethers.utils.parseEther("2000"));
  kvs.transfer(staking.address, ethers.utils.parseEther("2000"));


  console.log("IMPERSONATING")


  console.log("ADDRESS");
  
}



main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
