var ERC20Events = artifacts.require("ERC20Events");
var ERC20 = artifacts.require("ERC20");
var MatchingMarket = artifacts.require("MatchingMarket");
var MoneyMaker = artifacts.require("MoneyMaker");

module.exports = function(deployer) {
  deployer.deploy(MoneyMaker);
};
