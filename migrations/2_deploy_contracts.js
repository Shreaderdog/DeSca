const datacontract = artifacts.require("DESCATWO");
const daocontract = artifacts.require("Dao");

module.exports = async function(deployer, network, accounts) {
    await deployer.deploy(datacontract, 75, 3);
    const sensorcontract = await datacontract.deployed();

    await deployer.deploy(daocontract, 6, sensorcontract.address);
    const daoaddress = await daocontract.deployed();

    await sensorcontract.setupDAO(daoaddress.address);
}