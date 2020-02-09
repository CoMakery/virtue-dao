// const truffleAssert = require('truffle-assertions');
var VirtueDAO = artifacts.require("VirtueDAO");

contract("Access control tests", function (accounts) {
    var deployer
    var vDAO

    beforeEach(async function () {
        deployer = accounts[0]
        reserveAdmin = accounts[1]
        transferAdmin = accounts[2]
        unprivileged = accounts[5]

        vDAO = await VirtueDAO.new()
    })

    it("get maxAwardablePerPeriod", async () => {
        let maxAwardablePerPeriod = await vDAO.maxAwardablePerPeriod.call({
            from: deployer
        })
        maxAwardablePerPeriod = parseInt(maxAwardablePerPeriod)
        expect(maxAwardablePerPeriod).to.equal(100)
    })
})