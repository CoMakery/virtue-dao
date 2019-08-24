![](assets/cat-seraphim-2.jpg)

# Virtue DAO

The Virtue DAO is a new kind of decentralized autonomous organization that incentivizes virtuous swarm of autonomous agents aligned with the DAOs mission. Allies receive continuous EnDAOment funding based on their virtue. It's a Decentralized Autonomous Organization (DAO) with no proposals!

## STATUS: PROOF OF CONCEPT

Not suitable for funds you do not want to loose yet. Development and security audits needed.

## Technology

* Ethereum blockchain [solidity](https://solidity.readthedocs.io) smart contracts
* Javascript, [web3.js](https://web3js.readthedocs.io/en/v1.2.1/), node.js, [Truffle](www.trufflesuite.com)
* [MetaMask](https://metamask.io/) web wallet integration
* [Maker DAO, DAI](https://makerdao.com/en/dai/) stable coin backed by ETH but algorithmically pegged to USD value
* [Compound.finance](https://compound.finance) integration to allocate interest from the endowment fund 
* [rDAI](https://redeem.money) token wrap the Compound.finance cDAI for more flexible use
* Although Virtue DAO stand on their own currently, they are complimentary to proposal based smart contract frameworks like DAOstack and Aragon

## The Problem With DAO Proposals

Decentralized Autonomous Organizations (DAOs) help us fulfill a common purpose, allocate resources and coordinate activities.

**But** proposals take a long time to write, read and vote on. Voter turnout is often very low. Waiting for permission for proposals is not fast enough in fast moving scenarios or in large communities with lots of localized expertise and decisions. Proposals are not in the spirit of permissionless action and do-ocracy. 

## Virtuous Swarms of Agents With No Proposals

As a metaphor, consider a monastic order where individuals gain access to the resources of the monastic order based on adherence to the codified precepts. Monastic virtue and decentralized alignment towards a common mission are social algorithms. When the agents of an order (monks, knights, artists, activists) remain true to their mission and precepts, others who are inspired by their actions donate to the endowment. Mission and virtue based organizing has been critical in human history and its likely to remain so as long as there are humans in the loop. 

To get more utilitarian, many organizations have a mission, stated values and KPIs. These can be translated into the Virtue DAO framework. 

Here are some example "virtues" as we use them in the context of the Virtue DAO:
* Writes open source DAO governance code that is useful to DAO allies 
* Acts to support the welfare of other DAO allies
* Abstains from false speech
* Perseveres to the end in any enterprise begun
* Conscientiously uses funds granted from the Virtue DAO towards the DAOs mission

# Virtue DAO Use Cases 

## Ally Recognizes Another Allies Virtue by Awarding Virtue Tokens 

1. A initial ally or person with virtue receives virtue tokens over time to award to other allies
2. They award the tokens to other allies who's virtue they recognize 

![](assets/virtue-dao/award-virtue.png)

## Ally Claims Fellowship 

1. A person with a blockchain address embodies the virtues of the Virtue DAO
2. Someone at Virtue DAO sends them Virtue Tokens for their virtues and makes them a ally
3. The ally claims their DAI based on the amount of virtue they have been recognized with
4. Time passes and their past Virtue Tokens decay
5. They receive new Virtue Tokens
6. They claim their DAI based on the amount of virtue they have been recognized with

![](assets/virtue-dao/ally-funding.png)

## Patron Endows the DAO 

1. Likes the mission of the Virtue DAO and wants to support virtuous people and their projects to work towards the goal of the DAO  
2. Transfers funds in DAI to Compound to receive compound interest on loans
3. Delegates the interest from their DAI deposit to the Virtue Token Contract address using rDAI
4. When interest accrues it is allocated Virtuous allies through the Virtue DAO

![](assets/virtue-dao/patron-endowment.png)

## DAO Proposal Endows a Virtue DAO

1. An ally submits a proposal to another DAO to fund the Virtue DAO
2. The proposal is accepted
3. The Funding DAO transfers DAI to the Virtue DAOs smart contract address 
4. The funds are dispersed to virtue DAO allies in proportion to their virtue

![](assets/virtue-dao/dao-proposal-grant.png)


## The Virtue DAO Deployer Configures the Virtue DAO

1. The Virtue DAO deployer configures the projects mission and virtues
2. Configures the initialAlly blockchain addresses and the number of virtue tokens they receive
3. Deploys the virtue DAO contract

# Ally Virtue Calculations

Each user's virtue for the current period is calculated as:
```
virtue(user) = 
virtueAwards[ virtueTypes[0], time[t] ] * decay( time[t] ) +
virtueAwards[ virtueTypes[0], time[t - 1] ] * decay( time[t - 1] ) +
...
virtueAwards[ virtueTypes[n], time[t - i] ] * decay( time[t - i] ) 
```

To lower computation this is simplified by only storing the current virtue ratings and running a `decay(Users, Virtues)` function once and only once per period.

## Ally Dividend Calculations

For the current period each ally can withdraw:
```
fellowship(user) = (virtue(user) / totalVirtue) * currentEndowment
```

## Awardable Virtue Tokens Calculation

Each period, each ally of the Virtue DAO receives an allocation of virtue tokens. They can award these generic virtue tokens to any person for a specific virtue established by the DAO.

When the DAO is deployed there is an `awardableByInitialAllyAmount`. This is given to initial allies each period to make sure there are always some people who can continue to recognize virtue for the DAO. This amount should be less than the awardable amounts people control in an active Virtue DAO.

Each users allocation of tokens for the given period is
```
baseAmount( user ) = if( user is an initial ally) then awardableByInitalAllyAmount else 0

virtueTokenallocationThisPeriod(user) = 
baseAmount + ( (virtue(user) / maxVirtue) * maxAllocation )
```

# FAQs

**Why bother having a virtue token? Why not issued a stable coin directly?**

The intent of the Virtue DAO is to continuously fund virtuous people achieving a mission. To calculate the proportion of funds to allocate to each ally

**Do you apply for membership like other DAOs?**

No. If you have virtue you are considered an agent of the DAO and can claim a portion of the continuous distribution of funds. You also can award other people virtue.

**Do you keep your virtue forever?**

No. Virtue decays gradually over time. You must keep being virtuous and aligned to receive benefits.

**How is Virtue initially distributed? What if no one has remaining virtue?**

The initial agents can distribute some amount of virtue in every period, regardless of their current level of virtue. There may be a better solution to this, but we need to avoid locking funds because everyones virtue has decayed and no one should receive any tokens.

# Thanks!

* Megan Knab @ Veriledger for coming up with the word EnDAOment
* Pet3rPan from MetaCartel for the encouragement
* Miao for the rDAI integration coaching
* Real Crypto Cats for the Virtue DAO cat meme - Instagram [@realcryptocats](https://www.instagram.com/realcryptocats/)
* Harlan Wood for the ongoing dialog about Trust Graph

![](assets/cat-seraphim.jpg)