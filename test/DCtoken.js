const { expect } = require("chai");
const { ethers } = require("hardhat");

const bytes32 = require('bytes32');

describe("Greeter", function () {
  it("bad news", async function () {
    const [owner, addr1 ,addr2] = await ethers.getSigners();
    console.log("begian")
    const Greeter = await ethers.getContractFactory("SolidcToken");
    const greeter = await Greeter.deploy();
    await greeter.deployed();
    //console.log(await greeter.getMail('a'))
    //console.log(await greeter.debugFetchAll())
    //expect(await greeter.greet()).to.equal("Hello, world!");
    console.log("deployed~!")
    console.log(addr1.address)

    const setGreetingTx = await greeter.connect(addr1).earnToken ();
    await setGreetingTx.wait();
    console.log("🔥");
    console.log(await greeter.connect(addr1).readToken (addr1.address))
    const GreetingTx = await greeter.connect(addr1).earnToken ();
    await GreetingTx.wait();
    console.log("🔥");
    console.log(await greeter.connect(addr1).readToken (addr1.address))
    console.log("🔥counter");
    console.log(await greeter.connect(addr2).readToken(addr2.address))

    console.log("🔥counter");
    console.log(await greeter.readTokenMe())
    //console.log(await greeter.getMail('a'))
    //var datetime = await greeter.getData();
     //console.log("Find me:"+await greeter.greet( "0x3b893D040Cc9ccF3b8ECDee2CCD8DC69E1e4bb6F"));
    // expect(await greeter.greet()).to.equal("Hola, mundo!");
  });
});
