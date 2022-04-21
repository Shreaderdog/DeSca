# DeSca Dapp
A decentralized blockchain-based SCADA system project by students at the University of South Alabama
# GitHub Link: https://github.com/Shreaderdog/DeSca

# Getting Started with DeSca Dapp
1. Clone the project and install all the relavent packages via 'npm install'.
    a) Run 'npm install' in project directory
    b) Navigate(Change Directory) to the 'DeSCA/src/Client' folder.
    c) Run 'npm install' in 'Client'.
2. Download Ganche and MetatMask Extension
    a) Ganache Download: https://trufflesuite.com/ganache/
        b) Optional Tutorial for getting familiar with Ganache(Includes MetaMask Walkthrough): https://trufflesuite.com/tutorial/
    c) MetatMask Extension Download: https://metamask.io/download/
        d) Optional Guide for MetaMask: https://docs.metamask.io/guide/ 
3. Starting the DeSCA Dapp:
    a) Launch Ganache
    b) Migrate Contracts
    c) Start Client

## Launch Ganache
### Option 1: Using the command line version of Ganache(Will NOT save your local blockchain).
1. Open a new terminal in the project directory and run 'npx ganache-cli'  
2. Ensure port numbers are the same
    a) From the same terminal to find the Ganache port number
    b) In the 'truffle-config.js' project file, ensure Ganache port number is the same as 'port: ####'.
3. Additional Details: https://www.npmjs.com/package/ganache-cli

### Option 2: Using the Ganache Interface(REQUIRED to save your local blockchain).
1. Launch Ganache Application on local device.
    If you would like to save your local blockchain:
    2. Select 'New Workspace'
    3. Name your workspace
    4. Add Project to Workspace
        a) Click 'Add Project'
        b) Select and open the 'truffle-config.js' file from 'DeSCA' project
        c) Click 'Save Workspace'

    If you dont want to save your local blockchain:
    2. Select 'Quickstart'
    3. Add Project to Workspace
        a) Click 'Add Project'
        b) Select and open the 'truffle-config.js' file from 'DeSCA' project
        c) Click 'Save Workspace'
    4. Note: Saving and renaming your workspace can still be done at this point.
5. Ensure port numbers are the same
    a) Click the 'Server' tab to find the Ganache port number
    b) In the 'truffle-config.js' project file, ensure Ganache port number is the same as 'port: ####'.
6. Additional Details: https://github.com/trufflesuite/ganache-ui

## Migrate Contracts
1. Open a new terminal in the project directory
2. Compile and Deploy DeSCA Contracts
    a) Run 'npm truffle migrate --reset'

## Start Client
1. Open a new terminal in the project directory
2. Navigate(Change Directory) to the 'DeSCA/src/Client' folder.
3. Launch client
    a) Run 'npm start' script



## Available Script
### `npm start`

Runs the app in the development mode.\
Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

The page will reload when you make changes.\
You may also see any lint errors in the console.