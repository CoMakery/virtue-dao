pragma solidity ^0.5.8;
import "@openzeppelin/contracts/math/SafeMath.sol";

contract VirtueDAO {
    using SafeMath for uint;

    mapping(address => mapping(uint => uint)) public allyVirtues; // allyAddress => virtueId => pointBalance
    mapping(uint => mapping(address => uint)) public awardsMadeThisPeriod; // periodId => user => awardsMadeThisPeriod

    // point awards
    uint public maxVirtueId = 4; // zero indexed
    uint public maxAwardablePerPeriod = 100;
    uint public virtueRetainedPercent = 85;

    function getAwardsMadeThisPeriod(address _ally) public view returns (uint) {
        return awardsMadeThisPeriod[currentPeriod()][_ally];
    }

    function getRemainingAwardableThisPeriod(address _ally) public view returns (uint) {
        return maxAwardablePerPeriod.sub(getAwardsMadeThisPeriod(_ally));
    }

    function awardVirtue(address _ally, uint _virtueId, uint amount) public returns (uint) {
        require(awardsMadeThisPeriod[(currentPeriod())][msg.sender] < amount, "Error: not enough virtue to award");
        awardsMadeThisPeriod[(currentPeriod())][msg.sender] = awardsMadeThisPeriod[(currentPeriod())][msg.sender].add(amount);
        return allyVirtues[_ally][_virtueId] = allyVirtues[_ally][_virtueId].add(amount);
    }

    function virtueCount() public view returns (uint) {
        return maxVirtueId + 1;
    }

    function getVirtue(address _ally, uint _virtueId) public view returns (uint) {
        return allyVirtues[_ally][_virtueId];
    }

    function currentPeriod() public view returns (uint) {
        return now / 604800; // week number since the unix epoch
    }

    function decayVirtue(address _ally) public {
        uint _virtueId = 0;
        allyVirtues[_ally][_virtueId] = allyVirtues[_ally][_virtueId].mul(virtueRetainedPercent).div(100);
    }

    function virtueDecayPercent() public view returns (uint) {
        return 100 - virtueRetainedPercent;
    }

    // TODO: virtue CAP / max dividend 
    // TODO: these functions
    
    // function decayVirtue()

    // // Virtue -> rDAI: transferFrom(daoAddress, daoAllyAddress, amount)
    // // Ally1 -> DAI: transfer(recipientAddress, amount) \n// DAI is ally'
    // function claimFellowship() public {
    //     _calculateFellowship(msg.sender);
    // }

    // // based on virtue points received, max values,
    // // decay of virtue since it was awarded 
    // // endowment available during this period
    // function _calculateFellowship(address _ally) private {
    //     // stub
    // }

    // returns total funds available from patrons 
    // function endowmentBalance() public returns(uint) {
    //     // TODO: call external DAI address for balance
    //     return 0;
    // }
}