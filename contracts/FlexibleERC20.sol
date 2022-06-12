pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
contract FlexibleERC20 is ERC20 {
    //
    uint private currentBalance = 0;
    //
    // using ERC20 for IERC20;

    constructor() ERC20("FlexibleToken", "FLX") {
        Owner = msg.sender;
    }
    //init structor
    struct MasterOperation{
        uint Timestmp;
        uint Id;
        string Action;
        address From;
        address Target; 
    }

    struct MintOperation{
        uint Timestmp;
        uint Id;
        string Action;
        address From;
        address Target;
        string Details; 
        uint Fee;
    }
    
    MasterOperation[] private MasterOperationRecord;
    MintOperation[] private MintOperationRecord;
    MintOperation[] private BurnOperationRecord;
    //Array
    address[] MasterList;
    mapping(address=>bool) private isMaster;
    mapping(address=>uint) private MasterID;
    using Counters for Counters.Counter;
    Counters.Counter private MasterCounter;
    Counters.Counter private MasterOperationCounter;
    Counters.Counter private MintOperationCounter;
    Counters.Counter private BurnOperationCounter;
    //Owner
    address private Owner;
    mapping(address=>bool) private isOwner;

/**
 * Token Counstractor
 */
     function CurrentSupply () public view returns (uint) {
        return currentBalance;
    }
    function AddMaster(address master) public returns (bool) {
        require(msg.sender==Owner);
        MasterList.push(master);
        isMaster[master] = true;
        MasterID[master] = MasterCounter.current();
        MasterCounter.increment();
        MasterOperation memory tmpOperation;
        tmpOperation.Timestmp = block.timestamp;
        tmpOperation.Action="Add";
        tmpOperation.From = msg.sender;
        tmpOperation.Target = master;
        tmpOperation.Id= MasterOperationCounter.current();
        MasterOperationRecord.push(tmpOperation);
        MasterOperationCounter.increment();
        return true;
    }

    function StopMaster(address master) public returns (bool) {
        require(msg.sender==Owner);
        isMaster[master] = false;
        MasterOperation memory tmpOperation;
        tmpOperation.Timestmp = block.timestamp;
        tmpOperation.Action="Stop";
        tmpOperation.From = msg.sender;
        tmpOperation.Target = master;
        tmpOperation.Id= MintOperationCounter.current();
        MasterOperationRecord.push(tmpOperation);
        MasterOperationCounter.current();

        return true;
    }
    function ReadOwner () public view returns (address) {
        return Owner;
    }
    function ReadMasterList () public view returns (address[] memory) {
        return MasterList;
    }

    function ReadMasterOperationRecordIndex () public view returns (uint) {
        return MasterOperationCounter.current();
    }
    function ReadMasterOperationRecord (uint startIndex , uint endIndex) public view returns (string memory) {
        string memory tmp;
        if(MasterOperationRecord.length>startIndex){
        tmp = string(abi.encodePacked(tmp,
            '{',
            '"Timestmp":',Strings.toString(MasterOperationRecord[startIndex].Timestmp),",",
            '"Id":',Strings.toString(MasterOperationRecord[startIndex].Id),",",
            '"Action":"',MasterOperationRecord[startIndex].Action,'"',",",
            '"From":"',AddressToString(abi.encodePacked(MasterOperationRecord[startIndex].From)),'"',",",
            '"Target":"',AddressToString(abi.encodePacked(MasterOperationRecord[startIndex].Target)),'"',
            "}"
             ));
        for (uint i = startIndex+1 ;i<=endIndex ;i++  ){
             tmp = string(abi.encodePacked(tmp,
            ',{',
            '"Timestmp":',Strings.toString(MasterOperationRecord[i].Timestmp),",",
            '"Id":',Strings.toString(MasterOperationRecord[i].Id),",",
            '"Action":"',MasterOperationRecord[i].Action,'"',",",
            '"From":"',AddressToString(abi.encodePacked(MasterOperationRecord[i].From)),'"',",",
            '"Target":"',AddressToString(abi.encodePacked(MasterOperationRecord[i].Target)),'"',
            "}"
             ));
        }
        }

        return string(abi.encodePacked(
            "[",
            tmp,
            "]"
        ));
    }

    function MasterSaFeMint(address target,uint fee ,string memory details) public returns (bool) {
        require(isMaster[msg.sender]);
        currentBalance+=fee;
        MintOperation memory tmpOperation;
        tmpOperation.Timestmp = block.timestamp;
        tmpOperation.Action="Mint";
        tmpOperation.From = msg.sender;
        tmpOperation.Target = target;
        tmpOperation.Details = details;
        tmpOperation.Fee = fee;
        tmpOperation.Id= MintOperationCounter.current();
        MintOperationRecord.push(tmpOperation);
        MintOperationCounter.increment();
        _mint(target,fee);
        return true;
    }

    function ReadMintOperationRecordIndex () public view returns (uint) {
        return  MintOperationCounter.current();
    }
    function ReadMintOperationRecord (uint startIndex , uint endIndex) public view returns (string memory) {
        string memory tmp;
        if(MintOperationRecord.length>startIndex){
        tmp = string(abi.encodePacked(tmp,
            '{',
            '"Timestmp":',Strings.toString(MintOperationRecord[startIndex].Timestmp),",",
            '"Id":',Strings.toString(MintOperationRecord[startIndex].Id),",",
            '"Fee":',Strings.toString(MintOperationRecord[startIndex].Fee),",",
            '"Action":"',MintOperationRecord[startIndex].Action,'"',",",
            '"From":"',AddressToString(abi.encodePacked(MintOperationRecord[startIndex].From)),'"',",",
            '"Target":"',AddressToString(abi.encodePacked(MintOperationRecord[startIndex].Target)),'"',",",
            '"Details":"',MintOperationRecord[startIndex].Details,'"',
            "}"
             ));
        for (uint i = startIndex+1 ;i<=endIndex ;i++ ){
             tmp = string(abi.encodePacked(tmp,
            ',{',
            '"Timestmp":',Strings.toString(MintOperationRecord[i].Timestmp),",",
            '"Id":',Strings.toString(MintOperationRecord[i].Id),",",
            '"Fee":',Strings.toString(MintOperationRecord[i].Fee),",",
            '"Action":"',MintOperationRecord[i].Action,'"',",",
            '"From":"',AddressToString(abi.encodePacked(MintOperationRecord[i].From)),'"',",",
            '"Target":"',AddressToString(abi.encodePacked(MintOperationRecord[i].Target)),'"',",",
            '"Details":"',MintOperationRecord[i].Details,'"',
            "}"
             ));
        }
        }

        return string(abi.encodePacked(
            "[",
            tmp,
            "]"
        ));
    }

    function MasterSaFeBurn(uint fee ,string memory details) public returns (bool) {
        require(isMaster[msg.sender]);
        currentBalance-=fee;
        MintOperation memory tmpOperation;
        tmpOperation.Timestmp = block.timestamp;
        tmpOperation.Action="Burn";
        tmpOperation.From = msg.sender;
        tmpOperation.Target = msg.sender;
        tmpOperation.Details = details;
        tmpOperation.Fee = fee;
        tmpOperation.Id= MintOperationCounter.current();
        BurnOperationRecord.push(tmpOperation);
        BurnOperationCounter.increment();
        _burn(msg.sender,fee);
        return true;
    }

    function ReadBurnOperationRecordIndex () public view returns (uint) {
        return  BurnOperationCounter.current();
    }
    function ReadBurnOperationRecord (uint startIndex , uint endIndex) public view returns (string memory) {
        string memory tmp;
        if(BurnOperationRecord.length>startIndex){
        tmp = string(abi.encodePacked(tmp,
            '{',
            '"Timestmp":',Strings.toString(BurnOperationRecord[startIndex].Timestmp),",",
            '"Id":',Strings.toString(BurnOperationRecord[startIndex].Id),",",
            '"Fee":',Strings.toString(BurnOperationRecord[startIndex].Fee),",",
            '"Action":"',BurnOperationRecord[startIndex].Action,'"',",",
            '"From":"',AddressToString(abi.encodePacked(BurnOperationRecord[startIndex].From)),'"',",",
            '"Target":"',AddressToString(abi.encodePacked(BurnOperationRecord[startIndex].Target)),'"',",",
            '"Details":"',BurnOperationRecord[startIndex].Details,'"',
            "}"
             ));
        for (uint i = startIndex+1 ;i<=endIndex ;i++ ){
             tmp = string(abi.encodePacked(tmp,
            ',{',
            '"Timestmp":',Strings.toString(BurnOperationRecord[i].Timestmp),",",
            '"Id":',Strings.toString(BurnOperationRecord[i].Id),",",
            '"Fee":',Strings.toString(BurnOperationRecord[i].Fee),",",
            '"Action":"',BurnOperationRecord[i].Action,'"',",",
            '"From":"',AddressToString(abi.encodePacked(BurnOperationRecord[i].From)),'"',",",
            '"Target":"',AddressToString(abi.encodePacked(BurnOperationRecord[i].Target)),'"',",",
            '"Details":"',BurnOperationRecord[i].Details,'"',
            "}"
             ));
        }
        }

        return string(abi.encodePacked(
            "[",
            tmp,
            "]"
        ));
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

    function UintToJson(uint[] memory rawdata) public view returns (string memory) {
        string memory tmp;
        if(rawdata.length>0){
            tmp=Strings.toString(rawdata[0]);
        for (uint i = 1 ;i<rawdata.length ;i++ ){
             tmp = string(abi.encodePacked(tmp,",",Strings.toString(rawdata[i])));
        }
        }

        return string(abi.encodePacked(
            "[",
            tmp,
            "]"
        ));
    }

    function StringToJson(uint[] memory rawdata) public view returns (string memory) {
        string memory tmp;
        if(rawdata.length>0){
            tmp=Strings.toString(rawdata[0]);
        for (uint i = 1 ;i<rawdata.length ;i++ ){
             tmp = string(abi.encodePacked(tmp,",",rawdata[i]));
        }
        }

        return string(abi.encodePacked(
            "[",
            '"',tmp,'"',
            "]"
        ));
    }

        function AddressToJson(uint[] memory rawdata) public view returns (string memory) {
        string memory tmp;
        if(rawdata.length>0){
            tmp=Strings.toString(rawdata[0]);
        for (uint i = 1 ;i<rawdata.length ;i++ ){
             tmp = string(abi.encodePacked(tmp,",",rawdata[i]));
        }
        }

        return string(abi.encodePacked(
            "[",
            '"',tmp,'"',
            "]"
        ));
    }
    function arraySearch(uint[] memory rawdata , uint target) public view returns (bool) {
        if(rawdata.length==0){
            return false;
        }
        for(uint i =0 ;i<rawdata.length;i++){
            if(rawdata[i]==target){
                return true;
            }
        }
        return false;
    }

     function randomUint(uint seed,uint inner) private view returns (uint) {
         return uint(keccak256(abi.encodePacked(inner,block.difficulty, block.timestamp, seed)));
     }

     function AddressToString(bytes memory data) public pure returns(string memory) {
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(2 + data.length * 2);
        str[0] = "0";
        str[1] = "x";
        for (uint i = 0; i < data.length; i++) {
            str[2+i*2] = alphabet[uint(uint8(data[i] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
        }
        return string(str);
    }
}