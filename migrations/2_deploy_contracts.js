var ERC20Events = artifacts.require("ERC20Events");
var ERC20 = artifacts.require("ERC20");
var MatchingMarket = artifacts.require("MatchingMarket");
var MoneyMaker = artifacts.require("MoneyMaker");

module.exports = function(deployer) {
  deployer.deploy(ERC20Events);
  deployer.link(ERC20Events, ERC20);

  deployer.deploy(ERC20);
  deployer.link(ERC20, MatchingMarket);

  deployer.deploy(MatchingMarket);
  deployer.link(MatchingMarket, MoneyMaker);

  deployer.deploy(MoneyMaker);
};
