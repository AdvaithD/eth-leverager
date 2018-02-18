pragma solidity ^0.4.18;

// File found here:
// https://github.com/makerdao/maker-otc/blob/00cf7de5b8f61ec2bbee73dc64a62fa417d39661/src/matching_market.sol
contract MatchingMarket {
  function buyAllAmount(ERC20 buy_gem, uint buy_amt, ERC20 pay_gem, uint max_fill_amount) public returns (uint fill_amt);
  function sellAllAmount(ERC20 pay_gem, uint pay_amt, ERC20 buy_gem, uint min_fill_amount) public returns (uint fill_amt);
}
