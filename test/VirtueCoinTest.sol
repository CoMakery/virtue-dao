pragma solidity ^0.5.8;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/VirtueCoin.sol";

contract VirtueCoinTest {
    function testSomething() public {
        VirtueCoin virtueCoin = VirtueCoin(DeployedAddresses.VirtueCoin());
        // bytes32 virtue = "nice";
        // Assert.equal(virtueCoin.checkVirtue(msg.sender, virtue), 0, "should not have virtue by default");
        uint nada = 0;
        Assert.equal(virtueCoin.endowmentBalance(), nada, "should start with no endowment");
    }    
}