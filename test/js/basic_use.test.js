// const truffleAssert = require('truffle-assertions');
const VirtueDAO = artifacts.require("VirtueDAO");

contract("Access control tests", function (accounts) {
    var deployer, vDAO, alice, bob

    beforeEach(async function () {
        deployer = accounts[0]
        alice = accounts[1]
        bob = accounts[2]

        vDAO = await VirtueDAO.new()
    })

    it("get maxAwardablePerPeriod", async () => {
        let maxAwardablePerPeriod = (await vDAO.maxAwardablePerPeriod.call({
            from: deployer
        })).toNumber()
        expect(maxAwardablePerPeriod).to.equal(100)
    })
    it('check virtue', async () => {
        let virtue = parseInt(await vDAO.getVirtue(alice, 0))
        expect(virtue).to.equal(0)
    })

    it('issue virtue', async () => {
        await vDAO.awardVirtue(bob, 0, 100, {
            from: alice
        })
        let virtue = (await vDAO.getVirtue(bob, 0)).toNumber()
        expect(virtue).to.equal(100)
    })

    it('check amount awardable this period', async () => {
        let awardable = (await vDAO.getRemainingAwardableThisPeriod(alice)).toNumber()
        expect(awardable).to.equal(100)
        await vDAO.awardVirtue(bob, 0, 100, {
            from: alice
        })
    })
})