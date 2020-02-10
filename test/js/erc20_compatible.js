const truffleAssert = require('truffle-assertions')
const {advanceTime} = require('./helpers/helpers.js')
const VirtueDAO = artifacts.require("VirtueDAO")
const secondsPerWeek = 604800


contract("Access control tests", function (accounts) {
    var deployer, vDAO, alice, bob

    beforeEach(async function () {
        deployer = accounts[0]
        alice = accounts[1]
        bob = accounts[2]

        vDAO = await VirtueDAO.new()
    })

    it("check ERC20 details", async () => {
        expect((await vDAO.decimals()).toNumber()).to.equal(0)
        expect((await vDAO.name())).to.equal('Virtue DAO Alpha')
        expect((await vDAO.symbol())).to.equal('VDAOA')
    })

    it("does not allow approving transfers by others in this version", async () => {
        await truffleAssert.reverts(vDAO.approve(bob, 100, {
            from: alice
        }), "Error: cannot approve transfer of virtue by other accounts")

        await truffleAssert.reverts(vDAO.transferFrom(alice, bob, 100, {
            from: bob
        }), "Error: cannot transfer virtue on behalf of other accounts")
        
        let allowance = (await vDAO.allowance(alice, bob)).toNumber()
        expect(allowance).to.equal(0)
    })
})