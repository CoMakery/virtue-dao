document.addEventListener('DOMContentLoaded', run)

window.Web3 = require('web3')
console.log("hi from main.js")

async function run() {
    window.daoAddress = '0xae438fdA1337a432c148B1C01d80d9C8Be47a391'

    let daoAddress = window.daoAddress
    let ethereum = window.ethereum;
    let web3 = window.web3;
    if (typeof ethereum !== 'undefined') {
        await ethereum.enable();
        web3 = new Web3(ethereum);
    } else if (typeof web3 !== 'undefined') {
        web3 = new Web3(web3.currentProvider);
    } else {
        web3 = new Web3(new Web3.providers.HttpProvider(process.env.WEB3_PROVIDER));
    }
    let addr = await web3.eth.getCoinbase()
    console.log(addr)

    document.querySelector('.coinbase').innerHTML = addr
    document.querySelector('.daoAddress').innerHTML = daoAddress 

    let abi = await util.getABI('/build/virtueDAO.json')
    let virtueDAO = new web3.eth.Contract(abi, daoAddress)
    window.virtueDAO = virtueDAO

    // let virtueCount = await virtueDAO.methods.virtueCount().call()
    // console.log(virtueCount)
    let virtues = new Array
    for(let i = 0; i < 5; i++) {
        virtues.push(await virtueDAO.methods.getVirtue(daoAddress, 0).call())
    }
    console.log(virtues)
    //     await virtueDAO.methods.getVirtue(daoAddress, 0).
    //     call().
    //     then((e,i) => console.log(i))
}
