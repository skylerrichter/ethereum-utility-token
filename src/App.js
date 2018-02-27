import React, { Component } from 'react'
import TokenContract from '../build/contracts/Token.json'
import getWeb3 from './utils/getWeb3'

import './css/open-sans.css'
import './App.css'

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      contract: null,
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

    const contract = require('truffle-contract')
    const token = contract(TokenContract)
    token.setProvider(this.state.web3.currentProvider)
    token.deployed().then((contract) => {
      this.setState({
        contract
      })
    })

  }

  getBalance() {
    this.state.contract.balanceOf(this.state.address).then((balance) => {
      this.setState({
        balance: balance.toNumber()
      })
    })
  }

  transfer() {
    this.state.contract.transfer(this.state.to, this.state.value, {from: this.state.from}).then(() => {

    })
  }

  render() {
    return (
      <div>
        <h1>Check Balance</h1>
        <div>Address: <input type="text" onChange={(event) => this.setState({address: event.target.value})}/></div>
        <div>Balance: {this.state.balance}</div>
        <div><button onClick={() => this.getBalance()}>Fetch</button></div>
        <h1>Transfer</h1>
        <div>From: <input type="text" onChange={(event) => this.setState({from: event.target.value})}/></div>
        <div>To: <input type="text" onChange={(event) => this.setState({to: event.target.value})}/> </div>
        <div>Value: <input type="text" onChange={(event) => this.setState({value: event.target.value})}/> </div>
        <div><button onClick={() => this.transfer()}>Send</button></div>
      </div>
    );
  }
}

export default App
