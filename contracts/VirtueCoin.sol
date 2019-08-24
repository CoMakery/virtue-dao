pragma solidity ^0.5.8;

contract VirtueCoin {
    // TODO: add SafeMath back after sketch phase
    // using SafeMath for uint;

    mapping(bytes32 => mapping(address => uint)) virtueBalances;
    bytes32[] virtues; // constructor with initial members and virtues

    // Virtue -> Virtue: counstructor(foundingMembers, virtues) \n //initial members get virtue tokens of specific types to award

    // returns total funds available from patrons 
    function endowmentBalance() public returns(uint) {
        // stub
        return 0;
    }

    function checkVirtue(address _member, bytes32 _virtueType) public returns (uint) {
        //stub
        return 0;
    }
    function recognizeVirtueBalance(address _member, bytes32 _virtueType) public {
        // stub
    }
    function recognizeVirtue(address _member, bytes32 virtueType, uint amount) public {
        // stub
    }
    

    // Virtue -> rDAI: transferFrom(daoAddress, daoMemberAddress, amount)
    // Member1 -> DAI: transfer(recipientAddress, amount) \n// DAI is member'
    function claimFellowship() public {
        _calculateFellowship(msg.sender);
    }

    // based on virtue tokens received, max values,
    // decay of virtue since it was awarded 
    // endowment available during this period
    function _calculateFellowship(address _member) private {
        // stub
    }
}