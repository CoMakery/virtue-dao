pragma solidity ^0.5.8;
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/GSN/Context.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VirtueDAO is Context, IERC20 {
    using SafeMath for uint;

    string public symbol = "VDAOA";
    string public name = "Virtue DAO Alpha";
    uint8 public decimals = 0;
    uint public lastPeriodDecayed;
    address[] public allies; // TODO: find a way to decay without looping over allies each period
    mapping(address => bool) isFounder;
    
    uint _totalSupply = 0;

    mapping(address => uint) public allyVirtues; // allyAddress => pointBalance
    mapping(uint => mapping(address => uint)) public awardsMadeThisPeriod; // periodId => user => awardsMadeThisPeriod
    mapping(address => bool) public isAlly;
    // point awards
    uint public maxAwardablePerPeriod = 100;
    uint public virtueRetainedPercent = 80;
    uint public founderMinAwardable = 100;
    uint public nonFounderAwardableDivisor = 5;

    constructor(address[] memory _founders) public {
        for (uint i = 0; i < _founders.length; i++) {
            isFounder[_founders[i]] = true;
        }
        lastPeriodDecayed = (now / 604800);
    }

    function allyCount() public view returns (uint) {
        return allies.length;
    }
    function getAwardsMadeThisPeriod(address _ally) public view returns (uint) {
        return awardsMadeThisPeriod[currentPeriod()][_ally];
    }
    
    function getRemainingAwardableThisPeriod(address _ally) public view returns (uint) {
        return maxAwardableThisPeriod(_ally).sub(getAwardsMadeThisPeriod(_ally));
    }

    // non founders get 1/5 of their virtue to award
    // founders get greater of founderMinAwardable or 1/5 virtue
    // non one can exceed the max amount
    function maxAwardableThisPeriod(address _ally) public view returns (uint) {
        if(isFounder[_ally]) {
            return founderMinAwardable;
        } else {
            return allyVirtues[_ally] / nonFounderAwardableDivisor;
        }
    }

    // award virtue to a virtuous ally
    // virtue is awardable each period
    // TODO: find a way to decay without looping over allies each period
    function transfer(address _ally, uint amount) external returns (bool) {
        require((awardsMadeThisPeriod[(currentPeriod())][msg.sender] + amount) <= maxAwardableThisPeriod(msg.sender),
         "Error: not enough virtue to award");
        
        if(isAlly[_ally] == false) {
            allies.push(_ally);
            isAlly[_ally] = true;
        }

        awardsMadeThisPeriod[(currentPeriod())][msg.sender] = awardsMadeThisPeriod[(currentPeriod())][msg.sender].add(amount);
        allyVirtues[_ally] = allyVirtues[_ally].add(amount);
        _totalSupply = _totalSupply.add(amount);
        return true;
    }

    function balanceOf(address _ally) public view returns (uint) {
        return allyVirtues[_ally];
    }

    function currentPeriod() public view returns (uint) {
        return now / 604800; // week number since the unix epoch
    }


    function decayVirtue() public {
        if(lastPeriodDecayed < currentPeriod()) {
            for(uint i; i < allies.length; i++) {
                _decayVirtue(allies[i]);
            }
            lastPeriodDecayed = currentPeriod();
        }
    }
    
    function _decayVirtue(address _ally) private {
        allyVirtues[_ally] = allyVirtues[_ally].mul(virtueRetainedPercent).div(100);
    }

    function virtueDecayPercent() public view returns (uint) {
        return 100 - virtueRetainedPercent;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    // remains for ERC20 compatibility not used
    // may be implemented in a later version
    function allowance(address, address) external view returns (uint256) {
        return 0;
    }

    // remains for ERC20 compatibility not used
    // may be implemented in a later version
    function approve(address, uint256) external returns (bool) {
        require(false, "Error: cannot approve transfer of virtue by other accounts");
        return false;
    }

    // remains for ERC20 compatibility not used
    // may be implemented in a later version
    function transferFrom(address, address, uint256) external returns (bool) {
        require(false, "Error: cannot transfer virtue on behalf of other accounts");
        return false;
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