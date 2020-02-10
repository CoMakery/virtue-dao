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
        let virtue = parseInt(await vDAO.balanceOf(alice))
        expect(virtue).to.equal(0)
    })

    it('issue virtue', async () => {
        await vDAO.transfer(bob, 100, {
            from: alice
        })
        let virtue = (await vDAO.balanceOf(bob)).toNumber()
        expect(virtue).to.equal(100)
    })

    it('check amount awardable this period', async () => {
        let awardable = (await vDAO.getRemainingAwardableThisPeriod(alice)).toNumber()
        expect(awardable).to.equal(100)
        await vDAO.transfer(bob, 100, {
            from: alice
        })
    })
    
    it('can only award virtue up to the amount awardable this period', async () => {
        await vDAO.transfer(bob, 100, {
            from: alice
        })
        let remainingAwardable = (await vDAO.getRemainingAwardableThisPeriod(alice)).toNumber()
        expect(remainingAwardable).to.equal(0)

        await truffleAssert.reverts(vDAO.transfer(bob, 100, {
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
        await vDAO.transfer(bob, 100, {
            from: alice
        })
        let awardable = (await vDAO.getRemainingAwardableThisPeriod(alice)).toNumber()
        expect(awardable).to.equal(0)

        advanceTime(secondsPerWeek)
        awardable = (await vDAO.getRemainingAwardableThisPeriod(alice)).toNumber()
        expect(awardable).to.equal(100)
        await vDAO.transfer(bob, 100, {
            from: alice
        })
        awardable = (await vDAO.getRemainingAwardableThisPeriod(alice)).toNumber()
        expect(awardable).to.equal(0)
        advanceTime(secondsPerWeek)

        advanceTime(secondsPerWeek)
        awardable = (await vDAO.getRemainingAwardableThisPeriod(alice)).toNumber()
        expect(awardable).to.equal(100)
        await vDAO.transfer(bob, 100, {
            from: alice
        })
        awardable = (await vDAO.getRemainingAwardableThisPeriod(alice)).toNumber()
        expect(awardable).to.equal(0)
        advanceTime(secondsPerWeek)
    })

    it('virtue decays each period', async () => {
        expect((await vDAO.virtueDecayPercent()).toNumber()).to.equal(15)
        await vDAO.transfer(bob, 100, {
            from: alice
        })
        expect((await vDAO.balanceOf(bob)).toNumber()).to.equal(100)

        advanceTime(secondsPerWeek)
        await vDAO.decayVirtue()
        expect((await vDAO.balanceOf(bob)).toNumber()).to.equal(85)

        advanceTime(secondsPerWeek)
        await vDAO.decayVirtue()
        expect((await vDAO.balanceOf(bob)).toNumber()).to.equal(72)

        advanceTime(secondsPerWeek)
        await vDAO.decayVirtue()
        expect((await vDAO.balanceOf(bob)).toNumber()).to.equal(61)
    })

    it('awarding virtue increases the totalSupply() of virtue', async () => {
        expect((await vDAO.totalSupply()).toNumber()).to.equal(0)

        await vDAO.transfer(bob, 75, {
            from: alice
        })

        expect((await vDAO.totalSupply()).toNumber()).to.equal(75)
        
        await vDAO.transfer(alice, 80, {
            from: bob
        })
        expect((await vDAO.totalSupply()).toNumber()).to.equal(155)
    })

    it('last period decayed is initialized to the current period', async () => {
        expect((await vDAO.lastPeriodDecayed()).toNumber())
            .to.equal((await vDAO.currentPeriod()).toNumber())
    })

    it('decayVirtue only can be called once per period', async () => {
        await vDAO.transfer(bob, 100, {
            from: alice
        })
        expect((await vDAO.balanceOf(bob)).toNumber()).to.equal(100)
        
        advanceTime(secondsPerWeek)
        await vDAO.decayVirtue()
        expect((await vDAO.balanceOf(bob)).toNumber()).to.equal(85)

        await vDAO.decayVirtue()
        expect((await vDAO.balanceOf(bob)).toNumber()).to.equal(85)

        advanceTime(secondsPerWeek)
        await vDAO.decayVirtue()
        expect((await vDAO.balanceOf(bob)).toNumber()).to.equal(72)
    })

    it('decayVirtue decays all allies virtue', async () => {
        await vDAO.transfer(bob, 100, {
            from: alice
        })

        await vDAO.transfer(alice, 100, {
            from: bob
        })

        advanceTime(secondsPerWeek)
        await vDAO.decayVirtue()

        expect((await vDAO.balanceOf(alice)).toNumber()).to.equal(85)
        expect((await vDAO.balanceOf(bob)).toNumber()).to.equal(85)
    })

    it('only adds an ally to the allies list once', async () => {
        expect((await vDAO.allyCount()).toNumber()).to.equal(0)

        await vDAO.transfer(bob, 10, {
            from: alice
        })
        expect((await vDAO.allyCount()).toNumber()).to.equal(1)


        await vDAO.transfer(bob, 10, {
            from: alice
        })
        expect((await vDAO.allyCount()).toNumber()).to.equal(1)
    })
})