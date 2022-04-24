<div id="top"></div>

# DeSca Dapp

A decentralized blockchain-based SCADA system project by students at the University of South Alabama

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#startingdesca">Starting DeSca</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

Project details

<p align="right">(<a href="#top">back to top</a>)</p>



### Built With

section for tools used

* [React.js](https://reactjs.org/)
* [Bootstrap](https://getbootstrap.com)
* [truffle](https://trufflesuite.com/truffle/)
* [Ganche](https://trufflesuite.com/ganache/)


<p align="right">(<a href="#top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started

Instructions on what is required to run DeSca.

### Prerequisites

need to list things we need to use the software and how to install them.

* npm
  ```sh
  npm install npm@latest -g
  ```
* truffle
  ```sh
  npm install truffle -g
  ```

### Installation

_Installation Commands and Links_

1. Clone the repo
   ```sh
   git clone https://github.com/Shreaderdog/DeSca.git
   ```
2. Install NPM packages in `DeSca` and `Client` Directories
   ```sh
   npm install
   ```
3. Download Ganche <br>
    <https://trufflesuite.com/ganache/>
    > Optional Tutorial for getting familiar with Ganache(Includes MetaMask Walkthrough): <https://trufflesuite.com/tutorial/>
    
4. Download MetaMask Extension <br>
    <https://metamask.io/download/>
    > Optional Guide for MetaMask: <https://docs.metamask.io/guide/>
   

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Starting DeSca:
### Launch Ganache
#### Option 1: Using the command line version of Ganache (Will NOT save your local blockchain)
1. Open a new terminal in the project directory and run `npx ganache-cli`  
2. Ensure `ganche-cli` and `truffle-config.js` port numbers are the same:
    1. `ganche-cli`'s port number is located in the terminal running the client.
    2. `truffle-config.js` project file, ensure Ganache port number is the same as `ganche-cli`.<br>
    Additional Details: <https://www.npmjs.com/package/ganache-cli>

#### Option 2: Using the Ganache Interface (REQUIRED to save your local blockchain)
1. Launch Ganache Application on local device.
2. Select `New Workspace`
3. Name your workspace
4. Add Project to Workspace
    1. Click `Add Project`
    2. Select and open the `truffle-config.js` file from `DeSca` project
    3. Click `Save Workspace`
5. Ensure port numbers are the same
    1. Click the `Server` tab to find the Ganache port number
    2. In the `truffle-config.js` project file, ensure Ganache port number is the same as `port: ####`.<br>
    Additional Details: <https://github.com/trufflesuite/ganache-ui>

### Migrate Contracts
1. Open a new terminal in the project directory
2. Compile and Deploy DeSca Contracts
    1. Run ```npm truffle migrate --reset```

### Start Client
1. Open a new terminal in the project directory
2. Navigate(Change Directory) to the `DeSca/src/Client` folder.
3. Launch client
    1. Run `npm start` script

## Script to Start Client

### `npm start`

Runs the app in the development mode.\
Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

The page will reload when you make changes.\
You may also see any lint errors in the console.

<p align="right">(<a href="#top">back to top</a>)</p>
