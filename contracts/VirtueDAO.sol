pragma solidity ^0.5.8;
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/GSN/Context.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VirtueDAO is Context, IERC20 {
    using SafeMath for uint;

    string public symbol = "VDAOA";
    string public name = "Virtue DAO Alpha";
    uint8 public decimals = 0;

    mapping(address => uint) public allyVirtues; // allyAddress => pointBalance
    mapping(uint => mapping(address => uint)) public awardsMadeThisPeriod; // periodId => user => awardsMadeThisPeriod

    // point awards
    uint public maxAwardablePerPeriod = 100;
    uint public virtueRetainedPercent = 85;

    function getAwardsMadeThisPeriod(address _ally) public view returns (uint) {
        return awardsMadeThisPeriod[currentPeriod()][_ally];
    }

    function getRemainingAwardableThisPeriod(address _ally) public view returns (uint) {
        return maxAwardablePerPeriod.sub(getAwardsMadeThisPeriod(_ally));
    }

    function awardVirtue(address _ally, uint amount) public returns (uint) {
        require(awardsMadeThisPeriod[(currentPeriod())][msg.sender] < amount, "Error: not enough virtue to award");
        awardsMadeThisPeriod[(currentPeriod())][msg.sender] = awardsMadeThisPeriod[(currentPeriod())][msg.sender].add(amount);
        return allyVirtues[_ally] = allyVirtues[_ally].add(amount);
    }

    function balanceOf(address _ally) public view returns (uint) {
        return allyVirtues[_ally];
    }

    function currentPeriod() public view returns (uint) {
        return now / 604800; // week number since the unix epoch
    }

    function decayVirtue(address _ally) public {
        allyVirtues[_ally] = allyVirtues[_ally].mul(virtueRetainedPercent).div(100);
    }

    function virtueDecayPercent() public view returns (uint) {
        return 100 - virtueRetainedPercent;
    }

    function totalSupply() external view returns (uint256) {
        return 0;
    }

    function transfer(address recipient, uint256 amount) external returns (bool) {
        return false;
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return 0;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        return false;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
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