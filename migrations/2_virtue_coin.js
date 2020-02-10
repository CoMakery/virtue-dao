const VirtueDAO = artifacts.require("VirtueDAO");

module.exports = function(deployer, newtork, accounts) {
  deployer.deploy(VirtueDAO, [accounts[0]]);
};
