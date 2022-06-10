//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract stabletoken3 is ERC20 {
    //Init the fee
    uint constant _initial_supply = 100000000000 * (10**18);
    //How much left
    uint currentBalance = _initial_supply;
    constructor() ERC20("DC3", "DC3") {
        // _mint(msg.sender, _initial_supply);
    }

    function earnToken () public {
        uint balanceChange = 1000 * (10**18);
        if(currentBalance>balanceChange){
            _mint(msg.sender, balanceChange);
            currentBalance = currentBalance - balanceChange; 
        }

    }
    
    function readToken (string memory add) public view returns (uint) {
        return balanceOf(parseAddr(add));
    }

    function readTokenMe() public view returns (uint) {
        return currentBalance;
    }

    //tools
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