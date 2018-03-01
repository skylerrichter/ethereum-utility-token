pragma solidity ^0.4.16;

/**
 * https://www.ethereum.org/crowdsale
 */
interface ERC20Interface {
  function transfer(address receiver, uint amount) public;
}

contract Crowdsale {
  
  /**
   * Address that should receive the funding if the goal is met.
   */
  address public beneficiary;

  /**
   * Funding goal to reach in Ether.
   */
  uint public fundingGoal;

  /**
   * Total amount raised so far.
   */
  uint public amountRaised;

  /**
   * Funding deadline.
   */
  uint public deadline;

  /**
   * Price of each token in Ether.
   */
  uint public price;

  /**
   */
  ERC20Interface public reward;

  /**
   */
  mapping(address => uint256) public balanceOf;

  /**
   */
  bool fundingGoalReached = false;

  /**
   */
  bool crowdsaleClosed = false;

  /**
   */
  event GoalReached(address recipient, uint totalAmountRaised);

  /**
   */
  event FundTransfer(address backer, uint amount, bool isContribution);

  /**
   */
  function Crowdsale(
    address isSuccessfulSendTo, 
    uint fundingGoalInEther, 
    uint durationInMinutes, 
    uint etherCostOfEachToken, 
    address addressOfTokenUsedAsReward
  ) public {
    beneficiary = isSuccessfulSendTo;
    fundingGoal = fundingGoalInEther * 1 ether;
    deadline = now + durationInMinutes * 1 minutes;
    price = etherCostOfEachToken * 1 ether;
    reward = ERC20Interface(addressOfTokenUsedAsReward);
  }

  /**
   */
  function () public payable {
    require(!crowdsaleClosed);
    uint amount = msg.value;
    balanceOf[msg.sender] += amount;
    amountRaised += amount;
    reward.transfer(msg.sender, amount / price);
    FundTransfer(msg.sender, amount, true);
  }

}