const VirtueDAO = artifacts.require("VirtueDAO");

module.exports = function(deployer) {
  deployer.deploy(VirtueDAO);
};
