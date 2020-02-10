pragma solidity ^0.5.8;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/VirtueDAO.sol";

contract VirtueDAOTest {
    VirtueDAO virtueDAO;

    function beforeEach() public {
        virtueDAO = VirtueDAO(DeployedAddresses.VirtueDAO());
    }

    function testCheckingVirtue() public {
        uint nada = 0;
        Assert.equal(virtueDAO.balanceOf(msg.sender), nada, "should start with no endowment");
    }
}