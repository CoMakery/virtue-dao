pragma solidity ^0.5.8;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/VirtueCoin.sol";

contract VirtueCoinTest {
    VirtueCoin virtueCoin;

    function beforeEach() public {
        virtueCoin = VirtueCoin(DeployedAddresses.VirtueCoin());
    }

    function testCheckingVirtues() public {
        bytes32 virtueType = "nice";
        uint nada = 0;
        Assert.equal(virtueCoin.checkVirtue(msg.sender, virtueType), nada, "should start with no endowment");
    }    


    function testGetVirtues() public {
        Assert.equal(virtueCoin.virtueCount(), 2, "should return a count");
    }
}