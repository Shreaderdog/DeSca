# DeSca Dapp

A decentralized blockchain-based SCADA system project by students at the University of South Alabama

# Getting Started with DeSca Dapp

1. Clone the project and install all the relavent packages via 'npm install'.
    1. Run 'npm install' in project directory
    2. Navigate(Change Directory) to the 'DeSCA/src/Client' folder.
    3. Run 'npm install' in 'Client'.
2. Download Ganche and MetatMask Extension
    1. Ganache Download: <https://trufflesuite.com/ganache/>
        > Optional Tutorial for getting familiar with Ganache(Includes MetaMask Walkthrough): <https://trufflesuite.com/tutorial/>
    2. MetatMask Extension Download: <https://metamask.io/download/>
        > Optional Guide for MetaMask: <https://docs.metamask.io/guide/>
3. Starting the DeSCA Dapp:
    1. Launch Ganache
    2. Migrate Contracts
    3. Start Client

## Launch Ganache

> ### Option 1: Using the command line version of Ganache(Will NOT save your local blockchain)
> 
> 1. Open a new terminal in the project directory and run 'npx ganache-cli'  
> 2. Ensure port numbers are the same
>     1. From the same terminal to find the Ganache port number
>     2. In the 'truffle-config.js' project file, ensure Ganache port number is the same as 'port: ####'.
> 3. Additional Details: <https://www.npmjs.com/package/ganache-cli>
> 
> ### Option 2: Using the Ganache Interface(REQUIRED to save your local blockchain)
> 
> 1. Launch Ganache Application on local device.
>     - If you would like to save your local blockchain:
>         >
>         > 1. Select 'New Workspace'
>         > 2. Name your workspace
>         > 3. Add Project to Workspace
>         >     1. Click 'Add Project'
>         >     2. Select and open the 'truffle-config.js' file from 'DeSCA' project
>         >     3. Click 'Save Workspace'
> 
>     - If you dont want to save your local blockchain:
>         >
>         > 1. Select 'Quickstart'
>         > 2. Add Project to Workspace
>         >     1. Click 'Add Project'
>         >     2. Select and open the 'truffle-config.js' file from 'DeSCA' project
>         >     3. Click 'Save Workspace'
>         > 3. Note: Saving and renaming your workspace can still be done at this point.
> 2. Ensure port numbers are the same
>     1. Click the 'Server' tab to find the Ganache port number
>     2. In the 'truffle-config.js' project file, ensure Ganache port number is the same as 'port: ####'.
> 3. Additional Details: <https://github.com/trufflesuite/ganache-ui>

## Migrate Contracts

1. Open a new terminal in the project directory
2. Compile and Deploy DeSCA Contracts
    1. Run 'npm truffle migrate --reset'

## Start Client

1. Open a new terminal in the project directory
2. Navigate(Change Directory) to the 'DeSCA/src/Client' folder.
3. Launch client
    1. Run 'npm start' script

## Available Script

### `npm start`

Runs the app in the development mode.\
Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

The page will reload when you make changes.\
You may also see any lint errors in the console.
