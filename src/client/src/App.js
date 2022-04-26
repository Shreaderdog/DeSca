import React, { Component } from "react";
import DeSCA from "./contracts/DeSCA.json";
import Dao from "./contracts/Dao.json";
import getWeb3 from "./components/getWeb3";
import Sensorgraph from "./components/sensorgraph";

import "./App.css";

// see if index 0 of accounts is the current address
// test switching accounts to see, or there may be a function to get the current account

class App extends Component {
  state = { labelinfo: {title: 'test', labels: ['mon', 'tues', 'wed', 'thurs']}, datapoints: [1, 2, 3, 4], numsensors: 0, web3: null, accounts: null, descacontract: null, daocontract: null, address_input: "" };

  handleChange = async (event) => {
    this.setState({address_input: event.target.value});
  }

  handleSubmit = async (event) => {
    event.preventDefault();

    if (this.state.web3.utils.isAddress(this.state.address_input)) {
      this.state.daocontract.methods.addVoter(this.state.address_input).send({ from: this.state.accounts[0] }).then(function(receipt) {
        console.log("ye");
      });
    } else {
      alert("Invalid address given!");
    }
  }

  componentDidMount = async () => {
    console.log(this.state.labelinfo);
    console.log(this.state.datapoints);
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const descadeployedNetwork = DeSCA.networks[networkId];
      const descainstance = new web3.eth.Contract(
        DeSCA.abi,
        descadeployedNetwork && descadeployedNetwork.address,
      );

      const daodeployedNetwork = Dao.networks[networkId];
      const daoinstance = new web3.eth.Contract(
        Dao.abi,
        daodeployedNetwork && daodeployedNetwork.address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3: web3, accounts: accounts, descacontract: descainstance, daocontract: daoinstance}, this.runExample);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  runExample = async () => {
    const { accounts, descacontract } = this.state;
    // get numer of sensors
    const response = await descacontract.methods.getTotalSensors().call();
    // Update state with the result.
    this.setState({ numsensors: response });
  };

  voteNo = async(e) => {
    e.preventDefault();

    const { daocontract } = this.state;

    await daocontract.methods.vote(false).send({from: this.state.accounts[0]});
  }

  voteYes = async(e) => {
    e.preventDefault();

    const  { daocontract } = this.state;

    await daocontract.methods.vote(true).send({from: this.state.accounts[0]});
  }

  getDecision = async(e) => {
    e.preventDefault();

    console.log("ran");

    await this.state.daocontract.methods.print_decision().send({ from: this.state.accounts[0] }).then(function(receipt) {
      console.log(receipt);
    });
  }

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>Good to Go!</h1>
        <p>Your Truffle Box is installed and ready.</p>
        <h2>Smart Contract Example</h2>
        <p>
          If your contracts compiled and migrated successfully, below will show
          a stored value of 5 (by default).
        </p>
        <p>
          Try changing the value stored on <strong>line 42</strong> of App.js.
        </p>
        <div>The stored value is: {this.state.numsensors}</div>
        <Sensorgraph labelinfo={this.state.labelinfo} datapoints={this.state.datapoints}/>
        <button onClick={App.voteNo}>Vote No</button>
        <button onClick={App.voteYes}>Vote Yes</button>
        <form onSubmit={this.handleSubmit}>
          <input type="text" placeholder="Voter address" value={this.state.value} onChange={this.handleChange} />
          <input type="submit" value="Add voter" />
        </form>
        <button onClick={this.getDecision}>Get Decision</button>
      </div>
    );
  }
}

export default App;
