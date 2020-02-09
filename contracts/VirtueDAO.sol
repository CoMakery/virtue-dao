pragma solidity ^0.5.8;

contract VirtueDAO {
    // TODO: add SafeMath back after sketch phase
    // using SafeMath for uint;

    mapping(address => mapping(uint => uint)) public allyVirtues; // allyAddress => virtueId => pointBalance
    mapping(uint => mapping(address => uint)) public awardsMadeThisPeriod; // periodId => user => awardsMadeThisPeriod
    
    // point awards
    uint public maxVirtueId = 4; // zero index
    uint public maxAwardablePerPeriod = 100;
    uint public currentPeriod = 0;
    
    function getAwardsMadeThisPeriod(address _ally) public view returns (uint) {
        return awardsMadeThisPeriod[currentPeriod][_ally];
    }

    function getRemainingAwardableThisPeriod(address _ally) public view returns (uint) {
        return maxAwardablePerPeriod - getAwardsMadeThisPeriod(_ally);
    }
    
    function awardVirtue(address _ally, uint _virtueId, uint amount) public returns (uint) {
        require(awardsMadeThisPeriod[currentPeriod][msg.sender] < amount, "Error: not enough virtue to award");
        awardsMadeThisPeriod[currentPeriod][msg.sender] += amount;
        return allyVirtues[_ally][_virtueId] += amount;
    }
    
    function virtueCount() public view returns (uint) {
        return maxVirtueId + 1;
    }
    
    function getVirtue(address _ally, uint _virtueId) public view returns (uint) {
        return allyVirtues[_ally][_virtueId];
    }

    // TODO: virtue CAP / max dividend 
    // TODO: these functions
    
    // function nextPeriod()

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