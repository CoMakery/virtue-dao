pragma solidity ^0.5.8;

contract VirtueCoin {
    // TODO: add SafeMath back after sketch phase
    // using SafeMath for uint;

    mapping(uint => mapping(address => uint)) public virtueBalances; // virtuid => holderAddress => balance
    struct PeriodValues {
        
    }
    mapping(uint => mapping(address => PeriodValues)) public userPeriodValues;
    // token awards
    uint public maxVirtueId;
    uint public maxAwardablePerPeriod = 100;
    uint public currentPeriod = 0;

    constructor(uint _numberOfVirtues) public {
        if(_numberOfVirtues < 2) {
            maxVirtueId = 1;
        } else {
            maxVirtueId = _numberOfVirtues - 1;
        }
    }
    
    // returns total funds available from patrons 
    // function endowmentBalance() public returns(uint) {
    //     // stub
    //     return 0;
    // }
    
    function virtueCount() public view returns (uint) {
        return maxVirtueId + 1;
    }
    
    function checkVirtue(address _member, uint _virtueType) public view returns (uint) {
        //stub
        return 0;
    }
    
    function awardableThisPeriod(address _member) public view returns (uint) {
        return maxAwardablePerPeriod;
    }
    
    function awardedThisPeriod(address _member) {
        return maxAwardablePerPeriod;
    }
    
    // function recognizeVirtue(address _member, bytes32 virtueType, uint amount) public {
    //     // stub
    // }

    // // Virtue -> rDAI: transferFrom(daoAddress, daoMemberAddress, amount)
    // // Member1 -> DAI: transfer(recipientAddress, amount) \n// DAI is member'
    // function claimFellowship() public {
    //     _calculateFellowship(msg.sender);
    // }

    // // based on virtue tokens received, max values,
    // // decay of virtue since it was awarded 
    // // endowment available during this period
    // function _calculateFellowship(address _member) private {
    //     // stub
    // }
}