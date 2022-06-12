const { expect } = require("chai");
const { ethers } = require("hardhat");

const bytes32 = require('bytes32');

describe("FlexibleERC20", function () {
  it("All pass", async function () {
    const [owner, addr1 ,addr2] = await ethers.getSigners();
    console.log("begian")
    const Greeter = await ethers.getContractFactory("FlexibleERC20");
    const greeter = await Greeter.connect(addr1).deploy();
    await greeter.deployed();
    //console.log(await greeter.getMail('a'))
    //console.log(await greeter.debugFetchAll())
    //expect(await greeter.greet()).to.equal("Hello, world!");
    // console.log("deployed~!")
    // console.log(addr1.address)

    // const setGreetingTx = await greeter.connect(addr1).earnToken ();
    // await setGreetingTx.wait();
    // console.log("🔥");
    // console.log(await greeter.connect(addr1).readToken (addr1.address))
    // const GreetingTx = await greeter.connect(addr1).earnToken ();
    // await GreetingTx.wait();
    // console.log("🔥");
    console.log(await greeter.connect(addr1).ReadOwner())
    await greeter.connect(addr1).AddMaster(addr2.address)
    await greeter.connect(addr1).AddMaster(addr1.address)
    console.log(await greeter.connect(addr1).ReadMasterList())
    console.log(await greeter.connect(addr1).CurrentSupply ());
    await greeter.connect(addr2).MasterSaFeMint(addr1.address,100,"for test")
    await greeter.connect(addr2).MasterSaFeMint(addr2.address,130,"for test")
    await greeter.connect(addr2).MasterSaFeMint(addr1.address,110,"for test")
    await greeter.connect(addr2).MasterSaFeMint(addr2.address,210,"for test")
    await greeter.connect(addr2).MasterSaFeMint(addr1.address,9021,"for test")
    console.log(await greeter.connect(addr1).CurrentSupply ());
    await greeter.connect(addr1).MasterSaFeBurn(1234,"for burn")
    await greeter.connect(addr1).MasterSaFeBurn(1234,"Fuck me")
    console.log(await greeter.connect(addr1).balanceOf(addr2.address))
    console.log(await greeter.connect(addr1).ReadMasterOperationRecordIndex())
    console.log(await greeter.connect(addr1).ReadMasterOperationRecord(0,1))
    console.log(await greeter.connect(addr1).ReadMintOperationRecordIndex())
    console.log(await greeter.connect(addr1).ReadMintOperationRecord(2,4))
    console.log(await greeter.connect(addr1).ReadBurnOperationRecordIndex())
    console.log(await greeter.connect(addr1).ReadBurnOperationRecord(0,1))
    console.log(await greeter.connect(addr1).CurrentSupply ());
    console.log(await greeter.connect(addr1).totalSupply());
    // console.log("🔥counter");
    // console.log(await greeter.connect(addr2).readToken(addr2.address))

    // console.log("🔥counter");
    // console.log(await greeter.readTokenMe())
    //console.log(await greeter.getMail('a'))
    //var datetime = await greeter.getData();
     //console.log("Find me:"+await greeter.greet( "0x3b893D040Cc9ccF3b8ECDee2CCD8DC69E1e4bb6F"));
    // expect(await greeter.greet()).to.equal("Hola, mundo!");
  });
});
