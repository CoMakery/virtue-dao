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
    
    it('can only award virtue up to the amount awardable this period', async () => {
        await vDAO.awardVirtue(bob, 0, 100, {
            from: alice
        })
        let remainingAwardable = (await vDAO.getRemainingAwardableThisPeriod(alice)).toNumber()
        expect(remainingAwardable).to.equal(0)

        await truffleAssert.reverts(vDAO.awardVirtue(bob, 1, 100, {
            from: alice
        }), "Error: not enough virtue to award")

        remainingAwardable = (await vDAO.getRemainingAwardableThisPeriod(alice)).toNumber()
        expect(remainingAwardable).to.equal(0)
    })

    it('has a period per week',  async () => {
        let currentPeriod = (await vDAO.currentPeriod()).toNumber()

        let now = (await web3.eth.getBlock(await web3.eth.getBlockNumber())).timestamp
        let currentWeekSinceUnixEpoch = Math.floor(now / secondsPerWeek)

        expect(currentPeriod).to.equal(currentWeekSinceUnixEpoch)

        advanceTime(secondsPerWeek)
        currentPeriod = (await vDAO.currentPeriod()).toNumber()
        expect(currentPeriod).to.equal(currentWeekSinceUnixEpoch + 1)

        advanceTime(secondsPerWeek)
        currentPeriod = (await vDAO.currentPeriod()).toNumber()
        expect(currentPeriod).to.equal(currentWeekSinceUnixEpoch + 2)
    })

    it('get new tokens to award each week', async () => {
        await vDAO.awardVirtue(bob, 0, 100, {
            from: alice
        })
        let awardable = (await vDAO.getRemainingAwardableThisPeriod(alice)).toNumber()
        expect(awardable).to.equal(0)

        advanceTime(secondsPerWeek)
        awardable = (await vDAO.getRemainingAwardableThisPeriod(alice)).toNumber()
        expect(awardable).to.equal(100)
        await vDAO.awardVirtue(bob, 0, 100, {
            from: alice
        })
        awardable = (await vDAO.getRemainingAwardableThisPeriod(alice)).toNumber()
        expect(awardable).to.equal(0)
        advanceTime(secondsPerWeek)

        advanceTime(secondsPerWeek)
        awardable = (await vDAO.getRemainingAwardableThisPeriod(alice)).toNumber()
        expect(awardable).to.equal(100)
        await vDAO.awardVirtue(bob, 0, 100, {
            from: alice
        })
        awardable = (await vDAO.getRemainingAwardableThisPeriod(alice)).toNumber()
        expect(awardable).to.equal(0)
        advanceTime(secondsPerWeek)
    })

    it('virtue decays each period', async () => {
        expect((await vDAO.virtueDecayPercent()).toNumber()).to.equal(15)
        await vDAO.awardVirtue(bob, 0, 100, {
            from: alice
        })
        expect((await vDAO.getVirtue(bob, 0)).toNumber()).to.equal(100)

        advanceTime(secondsPerWeek)
        await vDAO.decayVirtue(bob)
        expect((await vDAO.getVirtue(bob, 0)).toNumber()).to.equal(85)

        advanceTime(secondsPerWeek)
        await vDAO.decayVirtue(bob)
        expect((await vDAO.getVirtue(bob, 0)).toNumber()).to.equal(72)

        advanceTime(secondsPerWeek)
        await vDAO.decayVirtue(bob)
        expect((await vDAO.getVirtue(bob, 0)).toNumber()).to.equal(61)
    })
})