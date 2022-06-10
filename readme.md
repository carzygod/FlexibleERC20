
# Flexible ERC20

** This contract is to mint a much flexble ERC20 token for contect connecting and profi using **
- Which including the :
	- Roles :
		- Owner
		- Master
	- Record
		- Master operation record
		- Mint operation record

# More Details
## Flexible ERC20 Contract

**Structors:**

- MasterList [Uint Array]
- isMaster [mapping(Address=>bool)]
- MasterID [mapping(Address=>Uint)]
- MasterOperationRecord
  - TimeStamp [Uint]
  - Actions [String] (AddMaster | RemoveMaster | StopMaster)
  - From [Address]
  - Target [String]
- MintOperationRecord
  - TimeStamp [Uint]
  - Actions [String] (NewlyMint)
  - From [Address]
  - Target [Address]
  - Details [String] (UniqueSnCode)

- MasterCounter
- MasterOperatoinCounter
- TransferOperationCounter



**Funtions:**

- AddMaster (Owneable)
  - Masterlist.push(new)
  - isMaster[address]=True
  - MasterID[address]=MasterCounter
  - MasterCounter++
  - MasterOperationRecord.push(new)
  - MasterOperationCounter++
- DelMaster(Owneable)
  - isMaster[address]=False
  - MasterID[address]=MasterCounter
  - MasterOperationRecord.push(del)
  - MasterOperationCounter++
- StopMaster(Owneable)
  - isMaster[address]=False
  - MasterID[address]=MasterCounter
  - MasterOperationRecord.push(Stop)
  - MasterOperationCounter++
- ReadMasterOperationRecord(Unauth)
  - Return MasterOperationRecord
- MasterSafeMint(Master)
  - SafeMint
  - MintOperationRecord.push(new)
- ReadMasterMintRecord(Unauth)
  - Return MintOperationRecord



**Interface:**

- function MasterSafeMint (address target , uint orderFee ,string orderSn)
