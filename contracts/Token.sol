pragma solidity ^0.4.16;

/**
 * An ERC-20 compatible token contract.
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
 * https://www.ethereum.org/token
 */
contract Token {
  
  /**
   * MUST trigger when tokens are transfered, including zero value transfers.
   */
  event Transfer(address indexed from, address indexed to, uint value); 

  /**
   * MUST trigger on any successful call to approve(address spender, uint value).
   */
  event Approval(address indexed owner, address indexed spender, uint value);

  /**
   * The mapping key is the owners address and the mapping value is the balance.
   */
  mapping(address => uint) balances;

  /**
   * The mapping key is the spender address and the mapping value is a mapping.
   */
  mapping(address => mapping(address => uint)) approvals;

  uint8 public decimals = 18;

  /**
   * Total number of issued tokens.
   */
  uint public supply;

  /**
   * The constructor will only be called once, when the contract is deployed.
   * When the contract is deployed an initial balance can be set.
   */
  function Token(uint initialBalance) public {
    supply = initialBalance * 10 ** uint256(decimals);

    // balances[msg.sender] = initialBalance;
    balances[address(this)] = supply;
    // supply = initialBalance;
  }

  /**
   * Return the total token supply.
   */
  function totalSupply() public constant returns (uint) {
    return supply;
  }

  /**
   * Returns the account balance of another account with address `owner`.
   */
  function balanceOf(address owner) public constant returns (uint) {
    return balances[owner];
  }

  /**
   * Ensure the balance will be greater after the transaction.
   */
  function safeToAdd(uint a, uint b) internal pure returns (bool) {
    return (a + b >= a);
  }

  /**
   * Transfers the `value` amount of tokens to address `to`.
   */
  function transfer(address to, uint value) public returns (bool) {
    //require(balances[msg.sender] >= value);
    //require(safeToAdd(balances[to], value));
    balances[msg.sender] -= value;
    balances[to] += value;
    Transfer(msg.sender, to, value);
    return true;
  }

  /**
   * Transfers `value` amount of tokens `from` address from to address `to`.
   * The transferFrom method is used for a withdraw workflow, allowing contracts to transfer tokens on your behalf.
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

  /**
   * Allows `spender` to withdraw from your account multiple times, up to the `value` amount.
   * If this function is called again it overwrites the current allowance with the `value`.
   */
  function approve(address spender, uint value) public returns (bool) {
    approvals[msg.sender][spender] = value;
    Approval(msg.sender, spender, value);
    return true;
  }

  /**
   * Returns the amount which `spender` is allowed to withdraw from `owner`.
   */
  function allowance(address owner, address spender) public constant returns (uint) {
    return approvals[owner][spender];
  }
}