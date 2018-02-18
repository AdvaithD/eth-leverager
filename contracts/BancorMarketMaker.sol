pragma solidity ^0.4.11;

contract IERC20Token {
    // these functions aren't abstract since the compiler emits automatically generated getter functions as external
    function name() public constant returns (string) {}
    function symbol() public constant returns (string) {}
    function decimals() public constant returns (uint8) {}
    function totalSupply() public constant returns (uint256) {}
    function balanceOf(address _owner) public constant returns (uint256) { _owner; }
    function allowance(address _owner, address _spender) public constant returns (uint256) { _owner; _spender; }

    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
}

contract BancorConverter {
    function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public returns (uint256);
}

contract EthLeverage {
    address private constant bancorConverterAddress = 0x578f3c8454F316293DBd31D8C7806050F3B3E2D8;

    IERC20Token private constant dai = IERC20Token(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359);
    IERC20Token private constant bancorErc20Eth = IERC20Token(0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315);
    IERC20Token private constant bancorToken = IERC20Token(0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C);
    IERC20Token private constant bancorDaiSmartTokenRelay = IERC20Token(0xee01b3AB5F6728adc137Be101d99c678938E6E72);

    // gives bancor permission to spend dai on behalf of the contract
    function approveBancorToSpendDai(uint _value) private returns(uint) {
        dai.approve(bancorConverterAddress, _value);
    }

    // min return is calculated on frontend by taking 95% of bancor sell dai price
    function sellDaiIntoEth(uint256 _amountDai, uint256 _minReturn) public returns (uint256) {
        BancorConverter bancor = BancorConverter(bancorConverterAddress);
        IERC20Token[] storage daiToEthConversionPath;
        daiToEthConversionPath[0] = dai;
        daiToEthConversionPath[1] = bancorDaiSmartTokenRelay;
        daiToEthConversionPath[2] = bancorDaiSmartTokenRelay;
        daiToEthConversionPath[3] = bancorDaiSmartTokenRelay;
        daiToEthConversionPath[4] = bancorToken;
        daiToEthConversionPath[5] = bancorToken;
        daiToEthConversionPath[6] = bancorErc20Eth;
        return bancor.quickConvert(daiToEthConversionPath, _amountDai, _minReturn);
    }



    // min return is calculated on frontend by taking 95% of bancor buy dai price
    function buyEthIntoDai(uint256 _amountEth, uint256 _minReturn) public returns (uint256) {
        BancorConverter bancor = BancorConverter(bancorConverterAddress);
        IERC20Token[] storage ethToDaiConversionPath;
        ethToDaiConversionPath[0] = bancorErc20Eth;
        ethToDaiConversionPath[1] = bancorToken;
        ethToDaiConversionPath[2] = bancorToken;
        ethToDaiConversionPath[3] = bancorDaiSmartTokenRelay;
        ethToDaiConversionPath[4] = bancorDaiSmartTokenRelay;
        ethToDaiConversionPath[5] = bancorDaiSmartTokenRelay;
        ethToDaiConversionPath[6] = dai;
        return bancor.quickConvert(ethToDaiConversionPath, _amountEth, _minReturn);
    }
}
