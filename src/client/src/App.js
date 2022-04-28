import React, { Component } from "react";
import DeSCATWO from "./contracts/DeSCATWO.json";
import Dao from "./contracts/Dao.json";
import getWeb3 from "./components/getWeb3";
import Sensorgraph from "./components/sensorgraph";

import "./App.css";

class App extends Component {
  state = {
    labelinfo: {
      title: 'Current Data',
      labels: ['mon', 'tues', 'wed', 'thurs']
    },
    web3: null,
    descacontract: null,
    daocontract: null,
    // User info
    is_admin: false,
    vote_status: 0,
    address_input: "",
    // DAO info
    expected_votes: null,
    votes: 0,
    dao_status: null,
    last_decided: null,
    //desca info
    total_sensors: 0,
    sensor_data: [0, 0, 0, 0, 0, 0],
    last_result: false,
    timer: [0, 0, 0, 0, 0, 0],
    recd: [false, false, false, false, false, false]
  };

  fetchUserInfo = async () => {
    let instance = this;

    await this.state.daocontract.methods.user_info().call().then(function(data) {
      instance.setState({
        is_admin: data[0],
        vote_status: data[1]
      });
    });
  }

  fetchDESCAInfo = async () => {
    const instance = this;

    await this.state.descacontract.methods.descaInfo().call().then(function(data) {
      let label = Array.from({length: data[0]}, (_, i) => i + 1);
      instance.setState({
        total_sensors: data[0],
        sensor_data: data[1],
        last_result: data[2],
        timer: data[3],
        recd: data[4],
        labelinfo: {
          title: instance.state.labelinfo.title,
          labels: label
        }
      });
    });
  }

  fetchDAOInfo = async () => {
    const instance = this;

    await this.state.daocontract.methods.dao_info().call().then(function(data) {
      instance.setState({
        expected_votes: data[0],
        votes: data[1],
        dao_status: data[2],
        last_decided: data[3]
      });
    });
  }

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
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const descadeployedNetwork = DeSCATWO.networks[networkId];
      const descainstance = new web3.eth.Contract(
        DeSCATWO.abi,
        descadeployedNetwork && descadeployedNetwork.address,
      );

      const daodeployedNetwork = Dao.networks[networkId];
      const daoinstance = new web3.eth.Contract(
        Dao.abi,
        daodeployedNetwork && daodeployedNetwork.address,
      );

      
      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3: web3, descacontract: descainstance, daocontract: daoinstance}, this.runExample);
      
      // Use web3 to get the user's account and set it as the default account for contract calls
      await web3.eth.getAccounts().then(function(accounts) {
        web3.eth.defaultAccount = accounts[0];
      });

      this.fetchDAOInfo();
      this.fetchUserInfo();
      this.fetchDESCAInfo();

      const instance = this;

      // Event lisener to handle the user changing their account via metamask
      window.ethereum.on('accountsChanged', function (accounts) {
        web3.eth.defaultAccount = accounts[0];
        instance.fetchUserInfo();
      })
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  voteYes = async(e) => {
    e.preventDefault();

    const instance = this;
    await this.state.daocontract.methods.vote(true).send({ from: this.state.web3.eth.defaultAccount }).then(function() {
      instance.fetchUserInfo();
      instance.fetchDAOInfo();
    });
  }

  voteNo = async(e) => {
    e.preventDefault();

    const instance = this;
    await this.state.daocontract.methods.vote(false).send({ from: this.state.web3.eth.defaultAccount }).then(function() {
      instance.fetchUserInfo();
      instance.fetchDAOInfo();
    });
  }

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }

    return (
      <div className="App">
        <h1>DeSca Dapp DAO</h1>
        <p>Current address: {this.state.web3.eth.defaultAccount} {this.state.is_admin ? (<b>(admin)</b>) : ("")}</p>
        
        <h2 className="section">Aggragated Data Info</h2>
        <p>Total Sensors: {this.state.total_sensors}</p>
        <p>Last Result from Sensors: {this.state.last_result}</p>
        <h3>Sensor Status:</h3>
        <div className="dataVis"> 
        {this.state.sensor_data.map((datapoint, i) => <span key={i}>Sensor #{i}: <br/> Sensor Value: {datapoint} <br/> Current Timeout Value: {this.state.timer[i]} <br/> Received This Cycle: {this.state.recd[i]}</span>)}
        </div>
        <Sensorgraph labelinfo={this.state.labelinfo} datapoints={this.state.sensor_data}/>


        <h2 className="section">DAO Info</h2>
        {(() => {
          if (this.state.dao_status == 0) {
            return (<h3 style={{color: "gray"}}>Waiting for voters</h3>)
          } else if (this.state.dao_status == 1) {
            return (<h3 style={{color: "green"}}>Vote Passed</h3>)
          } else if (this.state.dao_status == 2) {
            return (<h3 style={{color: "red"}}>Vote Failed</h3>)
          }
        })()}
        <p>{this.state.votes}/{this.state.expected_votes} Votes</p>

        {(() => {
          if (this.state.vote_status == 0) {
            return (<p>You are not a voter in this DAO</p>)
          } else if (this.state.vote_status == 1) {
            return (<>
              <button className="btn-primary" style={{marginRight: "10px"}} onClick={this.voteYes}>Vote Yes</button>
              <button className="btn-danger"  onClick={this.voteNo}>Vote No</button>
            </>)
          } else {
            return (<h2 style={{color: "red"}}>Vote Failed</h2>)
          }
        })()}

        {
          this.state.is_admin ? (
            <>
              <h3 className="section">Admin</h3>
              <form onSubmit={this.handleSubmit}>
                <input type="text" placeholder="Voter address" value={this.state.value} onChange={this.handleChange} />
                <input type="submit" value="Add voter" />
              </form>
            </>
          ) : ("")
        }
      </div>
    );
  }
}

export default App;
