pragma solidity ^0.4.18;

import "./ICDPContract.sol";

//To-Do: be sure to complete the ETH_Address authorization
contract Ethleverage {

	//events
	event LogCDPAddressChanged(address oldAddress, address newAddress);
	event LogDaiAddressChanged(address oldAddress, address newAddress);

	//Variables
	struct Investor {
		uint layers;				// number of layers down
		uint prinContr;			// principle contribution in Eth
		uint LR; 						// liquidation ratio
		bytes32[] CDPs;			//array of CDPs
	}

	mapping (address => Investor) public investors;
	address[] public investorAddresses;

	address public CDPContract;
	address public DaiContract;
	address public owner;

	uint public eth2Wei = 1e18;


	//Modifiers
	modifier onlyOwner {
		require(msg.sender == owner);
			_;
	}

	//Functions
	function Ethleverage(address _CDPaddr, address _Daiaddr) public {
		owner = msg.sender;
		CDPContract = _CDPaddr;
		DaiContract = _Daiaddr;
		ICDPContract(CDPContract).approve(address(this));
	}

	/* Workflow
	1. Convert ETH into WETH, 
	2. Convert WETH into PETH, 
	3. Open CDP
	4. Deposit PETH into CDP, 
	5. Withdraw DAI, 
	6. Purchase WETH with DAI via decentralized exchange
	7. Convert WETH into PETH 
	*/
	function leverage(/*uint _pricefloor*/) payable public returns (bool sufficient) {
		//TO-DO: w/ price floor or leverage ratio, determine the number of layers and LR
		uint calcLR;
		uint recycledPeth;
		uint layers = 4;

		Investor memory sender;
		sender = investors[msg.sender];
		investorAddresses.push(msg.sender);

		sender.layers = layers;
		sender.prinContr = msg.value;
		sender.LR = calcLR;

		recycledPeth = sender.prinContr;

		// for email contract reference: https://github.com/makerdao/sai/blob/master/src/tub.sol
		for (uint i = 0; i < layers; i++) {
			// Step 3. Open CDPContract and put CDP info to array
			bytes32 CDPInfo = ICDPContract(CDPContract).open();
			sender.CDPs[i] = CDPInfo;

			// 4. Deposit PETH into CDP
			CDPContract.lock(sender.CDPs[i], recycledPeth*eth2Wei); 

			// 5. Withdraw DAI
			CDPContract.draw(sender.CDPs[i], recycledPeth*eth2Wei); 

			//To-Do: 6. get Weth w/ Dia 7. Convert weth to peth
			//recycledPeth = 7.

			}

		return true;
	 }

		// Update the address of the makerDAO CDP contract
   function setCdpContract(address _addr) onlyOwner public returns (bool success) {
		require(_addr != address(0));
		address old = CDPContract;
		CDPContract = _addr;
		LogCDPAddressChanged(old, _addr);
		return true;
	 }

	 function setDaiContract(address _addr) onlyOwner public returns (bool success) {
		 require(_addr != address(0));
		 address old = DaiContract;
		 DaiContract = _addr;
		 LogDaiAddressChanged(old, _addr);
		 return true;
		}
}
