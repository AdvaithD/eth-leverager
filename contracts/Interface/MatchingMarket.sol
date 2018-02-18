pragma solidity ^0.4.18;

import "./ERC20.sol";

// File found here:
// https://github.com/makerdao/maker-otc/blob/00cf7de5b8f61ec2bbee73dc64a62fa417d39661/src/matching_market.sol
contract MatchingMarket {
  ERC20 token = ERC20(0xd0A1E359811322d97991E03f863a0C30C2cF029C);

  function buyAllAmount(ERC20 buy_gem, uint buy_amt, ERC20 pay_gem, uint max_fill_amount) public returns (uint fill_amt);
  function sellAllAmount(ERC20 pay_gem, uint pay_amt, ERC20 buy_gem, uint min_fill_amount) public returns (uint fill_amt);
}
