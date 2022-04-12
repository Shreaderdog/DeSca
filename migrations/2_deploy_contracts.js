const datacontract = artifacts.require("DeSCA");

module.exports = async function(deployer, network, accoutns) {
    await deployer.deploy(datacontract, 75, 3);
}