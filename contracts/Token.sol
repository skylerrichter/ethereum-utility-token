pragma solidity ^0.4.8;

/*
A simple ERC-20 token implementation.
https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
*/
contract Token {
  
  /*
  */
  event Transfer(address indexed from, address indexed to, uint value); 

  /*
  */
  event Approval(address indexed owner, address indexed spender, uint value);

  /*
  The mapping key is the owners address and the mapping value is the balance stored as uint.
  */
  mapping(address => uint) balances;

  /*
  The mapping key is the spender address and the mapping value is a mapping.
  */
  mapping(address => mapping(address => uint)) approvals;

  /*
  Total number of issued tokens.
  */
  uint public supply;

  /*
  The constructor will only be called once, when the contract is deployed.
  When the contract is deployed an initial balance can be set.
  */
  function Token(uint initialBalance) public {
    balances[msg.sender] = initialBalance;
    supply = initialBalance;
  }

  /*
  Get the total number of issued tokens.
  */
  function totalSupply() public constant returns (uint) {
    return supply;
  }

  /*
  Get the balance for a given address.
  */
  function balanceOf(address who) public constant returns (uint) {
    return balances[who];
  }

  /*
  Ensure the balance will be greater after the transaction.
  */
  function safeToAdd(uint a, uint b) internal returns (bool) {
    return (a + b >= a);
  }

  /*
  Transfers the value amount of tokens to address to.
  */
  function transfer(address to, uint value) public returns (bool) {
    require(balances[msg.sender] >= value);
    require(safeToAdd(balances[to], value));
    balances[msg.sender] -= value;
    balances[to] += value;
    Transfer(msg.sender, to, value);
    return true;
  }

  /*
  Transfers value amount of tokens from address from to address to.
  The transferFrom method is used for a withdraw workflow, allowing contracts to transfer tokens on your behalf.
  */
  function transferFrom(address from, address to, uint value) public returns (bool) {
    require(balances[from] >= value);
    require(approvals[from][msg.sender] >= value);
    require(safeToAdd(balances[to], value));
    approvals[from][msg.sender] -= value;
    balances[from] -= value;
    balances[to] += value;
    Transfer(from, to, value);
    return true;
  }

  /*
  Allow spender to withdraw from your account multiple times, up to the value amount.
  If this function is called again it overwrites the current allowance with the value.
  */
  function approve(address spender, uint value) public returns (bool) {
    approvals[msg.sender][spender] = value;
    Approval(msg.sender, spender, value);
    return true;
  }

  /*
  Returns the amount which spender is allowed to withdraw from owner.
  */
  function allowance(address owner, address spender) public constant returns (uint) {
    return approvals[owner][spender];
  }
}