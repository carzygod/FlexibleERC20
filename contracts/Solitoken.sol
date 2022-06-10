//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
/**
This contract is to mint a layer-2-stable-coin
Which including USDT / USDC / BUSD / DAI
 */

contract SoliToken is ERC20 {
    using SafeERC20 for IERC20;
    //Init the token
    uint constant _initial_supply = 100000000000 * (10**18);
    uint currentBalance = _initial_supply;

 /**
#############################################
    Init the target stablecoin and the pool
#############################################
*/
    address USDT_CONTRACT = address(0x89960be65611d2038762037e745cF3b4ABEB67C1);//USDT address
    uint USDT_BALANCE = 0;

    address USDC_CONTRACT = address(0x89960be65611d2038762037e745cF3b4ABEB67C1);//USDT address
    uint USDC_BALANCE = 0;

    address BUSD_CONTRACT = address(0x89960be65611d2038762037e745cF3b4ABEB67C1);//USDT address
    uint BUSD_BALANCE = 0;

    address DAI_CONTRACT = address(0x89960be65611d2038762037e745cF3b4ABEB67C1);//USDT address
    uint DAI_BALANCE = 0;
     /**
----------------------------------
      */

    //Init the contract
    constructor() IERC20("SoliToken", "Soli") {
    }

/**
##############################################
Staking the stable coin
##############################################
 */
    function StakingUSDT(uint change) public payable {
        IERC20 token = IERC20(USDT_CONTRACT);
        require(token.transferFrom(msg.sender, address(this),change));
        _mint(msg.sender, change);
        currentBalance = currentBalance - change;
        USDT_BALANCE = USDT_BALANCE + change;
    }

    function StakingUSDC(uint change) public payable {
        IERC20 token = IERC20(USDC_CONTRACT);
        require(token.transferFrom(msg.sender, address(this),change));
        _mint(msg.sender, change);
        currentBalance = currentBalance - change;
        USDC_BALANCE = USDC_BALANCE + change;
    }

    function StakingBUSD(uint change) public payable {
        IERC20 token = IERC20(BUSD_CONTRACT);
        require(token.transferFrom(msg.sender, address(this),change));
        _mint(msg.sender, change);
        currentBalance = currentBalance - change;
        BUSD_BALANCE =BUSD_BALANCE + change;
    }

    function StakingDAI(uint change) public payable {
        IERC20 token = IERC20(DAI_CONTRACT);
        require(token.transferFrom(msg.sender, address(this),change));
        _mint(msg.sender, change);
        currentBalance = currentBalance - change;
        DAI_BALANCE = DAI_BALANCE + change;
    }
/**
Staking over
-------------------------------------------------
 */

 /**
##############################################
Withdraw the stable coins
##############################################
  */
    function WithdrawUSDT(uint change) public payable {
        IERC20 token = IERC20(address(this)); 
        require(token.transferFrom(msg.sender, address(this),change));
        IERC20 dc = IERC20(USDT_CONTRACT);
        require(dc.transfer(msg.sender,change));
        currentBalance = currentBalance + change;
        USDT_BALANCE = USDT_BALANCE - change;
    }

    function WithdrawUSDC(uint change) public payable {
        IERC20 token = IERC20(address(this)); 
        require(token.transferFrom(msg.sender, address(this),change));
        IERC20 dc = IERC20(USDC_CONTRACT);
        require(dc.transfer(msg.sender,change));
        currentBalance = currentBalance + change;
        USDC_BALANCE = USDC_BALANCE - change;
    }

    function WithdrawBUSD(uint change) public payable {
        IERC20 token = IERC20(address(this)); 
        require(token.transferFrom(msg.sender, address(this),change));
        IERC20 dc = IERC20(BUSD_CONTRACT);
        require(dc.transfer(msg.sender,change));
        currentBalance = currentBalance + change;
        BUSD_BALANCE = BUSD_BALANCE - change;
    }
    function WithdrawDAI(uint change) public payable {
        IERC20 token = IERC20(address(this)); 
        require(token.transferFrom(msg.sender, address(this),change));
        IERC20 dc = IERC20(DAI_CONTRACT);
        require(dc.transfer(msg.sender,change));
        currentBalance = currentBalance + change;
        DAI_BALANCE = DAI_BALANCE - change;
    }

 /**
##############################################
Token informations
##############################################
  */
    function ReadBalance(string memory token) public view returns (uint) {
        return currentBalance;
    }
    function AccountBalance (string memory add) public view returns (uint) {
        return balanceOf(parseAddr(add));
    }

 /**
##############################################
Tools for help
##############################################
  */

//String to address
    function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
        bytes memory tmp = bytes(_a);
        uint160 iaddr = 0;
        uint160 b1;
        uint160 b2;
        for (uint i = 2; i < 2 + 2 * 20; i += 2) {
            iaddr *= 256;
            b1 = uint160(uint8(tmp[i]));
            b2 = uint160(uint8(tmp[i + 1]));
            if ((b1 >= 97) && (b1 <= 102)) {
                b1 -= 87;
            } else if ((b1 >= 65) && (b1 <= 70)) {
                b1 -= 55;
            } else if ((b1 >= 48) && (b1 <= 57)) {
                b1 -= 48;
            }
            if ((b2 >= 97) && (b2 <= 102)) {
                b2 -= 87;
            } else if ((b2 >= 65) && (b2 <= 70)) {
                b2 -= 55;
            } else if ((b2 >= 48) && (b2 <= 57)) {
                b2 -= 48;
            }
            iaddr += (b1 * 16 + b2);
            }
        return address(iaddr);
    }
}