const VirtueCoin = artifacts.require("VirtueCoin");

module.exports = function(deployer) {
  deployer.deploy(VirtueCoin);
};
