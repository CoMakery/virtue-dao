pragma solidity ^0.5.8;

contract VirtueDAO {
    // TODO: add SafeMath back after sketch phase
    // using SafeMath for uint;

    // mapping(uint => mapping(address => uint)) public virtueBalances; // virtuid => holderAddress => balance
    
    // struct MemberVirtue {
    //     uint[5] virtueBalances; // TODO: make this flexible
    //     uint totalVirtue;
    // }

    mapping(address => mapping(uint => uint)) public memberVirtues; // memberAddress => virtueType => balance
    mapping(uint => mapping(address => uint)) public awardsMadeThisPeriod; // periodId => user => awardsMadeThisPeriod
    
    // token awards
    uint public maxVirtueId = 5;
    uint public maxAwardablePerPeriod = 100;
    uint public currentPeriod = 0;
    
    // returns total funds available from patrons 
    // function endowmentBalance() public returns(uint) {
    //     // TODO: call external DAI address for balance
    //     return 0;
    // }
    
    function getAwardsMadeThisPeriod(address _member) public view returns (uint) {
        return awardsMadeThisPeriod[currentPeriod][_member];
    }

    function getRemainingAwardableThisPeriod(address _member) public view returns (uint) {
        return maxAwardablePerPeriod - getAwardsMadeThisPeriod(_member);
    }
    
    function awardVirtue(address _member, uint _virtueType, uint amount) public returns (uint) {
        return memberVirtues[_member][_virtueType] += amount;
    }
    
    function virtueCount() public view returns (uint) {
        return maxVirtueId + 1;
    }
    
    function getVirtue(address _member, uint _virtueType) public view returns (uint) {
        return memberVirtues[_member][_virtueType];
    }
    
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