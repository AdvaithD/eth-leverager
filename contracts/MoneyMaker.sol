pragma solidity ^0.4.18;

// import "./Interface/ERC20.sol";
import "./Interface/MatchingMarket.sol";

contract MoneyMaker {
  MatchingMarket public constant OasisDEX = MatchingMarket(0x8cf1Cab422A0b6b554077A361f8419cDf122a9F9);

  // MN weth: 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
  // MN dai: 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359

  // kovan weth: 0xd0a1e359811322d97991e03f863a0c30c2cf029c
  // kovan dai:  0xc4375b7de8af5a38a93548eb8453a498222c4ff2
  ERC20 public kWeth = ERC20(0xd0A1E359811322d97991E03f863a0C30C2cF029C);
  ERC20 public kDai  = ERC20(0xC4375B7De8af5a38a93548eb8453a498222C4fF2);

  // In our case, we want to buy ETH using Dai
  function buyAllAmount(
    ERC20 buy_gem,
    uint buy_amt,
    ERC20 pay_gem,
    uint max_fill_amount)
    public
    returns (uint fill_amt) {
      require(buy_amt > 0);
      require(max_fill_amount > 0);
      OasisDEX.buyAllAmount(buy_gem, buy_amt, pay_gem, max_fill_amount);
    }

  function buyAllEth() external returns (uint256) {
    uint256 buyAmount = kDai.balanceOf(msg.sender);
    uint256 maxFill = buyAmount;

    // Return the amount filled by OasisDEX
    // buyAmount is in Wei
    return buyAllAmount(kWeth, buyAmount, kDai, maxFill);
  }

  // Not sure if needed
  // possibly for use with the liquidate, buying dai wth eth. 
  function buyAllDai() external returns (uint256) {
    uint256 buyAmount = kWeth.balanceOf(msg.sender);
    uint256 maxFill = buyAmount;

    // Return the amount filled by OasisDEX
    return buyAllAmount(kDai, buyAmount, kWeth, maxFill);
  }

}
