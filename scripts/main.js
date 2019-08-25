window.Web3 = require('web3')
console.log("hi from main.js")

async function run() {
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
}

document.addEventListener('DOMContentLoaded', run)