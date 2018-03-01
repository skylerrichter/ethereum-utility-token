import React, { Component } from 'react'
import TruffleContract from 'truffle-contract'

import TokenContract from '../build/contracts/Token.json'
import CrowdsaleContract from '../build/contracts/Crowdsale.json'
import getWeb3 from './utils/getWeb3'

import './css/open-sans.css'
import './App.css'

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      contract: null,
      crowdsale: null,
      balance: 0,
      address: '',
      from: '',
      to: '',
      value: '',
      storageValue: 0,
      web3: null
    }
  }

  componentWillMount() {
    // Get network provider and web3 instance.
    // See utils/getWeb3 for more info.

    getWeb3
    .then(results => {
      this.setState({
        web3: results.web3
      })

      setInterval(() => {
        this.setState({
          from: results.web3.eth.accounts[0]
        })
      }, 1000)

      // Instantiate contract once web3 provided.
      this.instantiateContract()
    })
    .catch(() => {
      console.log('Error finding web3.')
    })
  }

  instantiateContract() {

    /*
     * SMART CONTRACT EXAMPLE
     *
     * Normally these functions would be called in the context of a
     * state management library, but for convenience I've placed them here.
     */

    const token = TruffleContract(TokenContract)
    token.setProvider(this.state.web3.currentProvider)
    token.deployed().then((contract) => {
      const allEvents = contract.allEvents({
        fromBlock: 0,
        toBlock: 'latest'
      });
      allEvents.watch((err, res) => {
        console.log(err, res);
      });
      this.setState({
        contract
      })
    })

    const crowdsale = TruffleContract(CrowdsaleContract)
    crowdsale.setProvider(this.state.web3.currentProvider)
    crowdsale.deployed().then((crowdsale) => {
      const allEvents = crowdsale.allEvents({
        fromBlock: 0,
        toBlock: 'latest'
      });
      allEvents.watch((err, res) => {
        console.log(err, res);
      });
      this.setState({
        crowdsale
      })
    })
 
  }

  getBalance() {
    this.state.contract.balanceOf(this.state.from).then((balance) => {
      this.setState({
        balance: balance.toNumber()
      })
    })
  }

  transfer() {
    this.state.contract.transfer(this.state.to, this.state.value, {from: this.state.from}).then(() => {

    })
  }

  buy() {
    this.state.crowdsale.sendTransaction({value: this.state.web3.toWei(this.state.amount, "ether"), from: this.state.from, gas: 90000000}).then(() => {
        console.log(arguments)
      })
  }

  render() {
    return (
      <div>
        <h1>Check Balance</h1>
        <div>Address: <input type="text" value={this.state.from} disabled/></div>
        <div>Balance: {this.state.balance}</div>
        <div><button onClick={() => this.getBalance()}>Fetch</button></div>
        <h1>Transfer</h1>
        <div>From: <input type="text" value={this.state.from} disabled/></div>
        <div>To: <input type="text" onChange={(event) => this.setState({to: event.target.value})}/> </div>
        <div>Value: <input type="text" onChange={(event) => this.setState({value: event.target.value})}/> </div>
        <div><button onClick={() => this.transfer()}>Send</button></div>
        <h1>Buy Tokens</h1>
        <div>Amount: <input type="text" onChange={(event) => this.setState({amount: event.target.value})}/> </div>
        <div><button onClick={() => this.buy()}>Shut Up And Take My Ether!</button></div>
      </div>
    );
  }
}

export default App
