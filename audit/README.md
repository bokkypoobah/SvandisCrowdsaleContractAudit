# Svandis Crowdsale Contract Audit

## Summary

[Svandis](https://svandis.io/) intends to run a crowdsale in the near future.

Bok Consulting Pty Ltd was commissioned to perform an audit on the Ethereum crowdsale smart contracts for Svandis.

This audit has been conducted on Svandis' source code in commits
[88b8ac4](https://github.com/svandisproject/smart-contract/commit/88b8ac47747e81f23d7e653affc3614691894845),
[62d4b53](https://github.com/svandisproject/smart-contract/commit/62d4b53fd32ec6f1c650bfc09890661652dae663),
[de9ebb3](https://github.com/svandisproject/smart-contract/commit/de9ebb3c6fd3295b1f98abef98f2364c744e4652) and
[2a33eab](https://github.com/svandisproject/smart-contract/commit/2a33eab2c3a0abd8f51ce5d9668c595bca9ff7e3).

No potential vulnerabilities have been identified in the crowdsale/token contract.

<br />

<hr />

## Table Of Contents

* [Summary](#summary)
* [Recommendations](#recommendations)
* [Potential Vulnerabilities](#potential-vulnerabilities)
* [Scope](#scope)
* [Limitations](#limitations)
* [Due Diligence](#due-diligence)
* [Risks](#risks)
* [Testing](#testing)
* [Code Review](#code-review)

<br />

<hr />

## Recommendations

* [x] **MEDIUM IMPORTANCE** For whitelisting, use a separate `whitelist` data structure instead of reusing the `allowed` data structure
  * [x] Updated in [62d4b53](https://github.com/svandisproject/smart-contract/commit/62d4b53fd32ec6f1c650bfc09890661652dae663)
* [x] **MEDIUM IMPORTANCE** Use the SafeMath library to prevent overflow and underflows. Sample code in [FixedSupplyToken.sol](https://github.com/bokkypoobah/Tokens/blob/master/contracts/FixedSupplyToken.sol)
  * [x] Updated in [62d4b53](https://github.com/svandisproject/smart-contract/commit/62d4b53fd32ec6f1c650bfc09890661652dae663)
* [x] **LOW IMPORTANCE** In *Svandis* `uint256 constant public decimals = 18;` should be of type `uint8`
  * [x] Updated in [62d4b53](https://github.com/svandisproject/smart-contract/commit/62d4b53fd32ec6f1c650bfc09890661652dae663)
* [x] **LOW IMPORTANCE** In *Sale*, `uint256 public preSaleRate;` is unused
  * [x] Removed in [de9ebb3](https://github.com/svandisproject/smart-contract/commit/de9ebb3c6fd3295b1f98abef98f2364c744e4652)
* [x] **LOW IMPORTANCE** In `Sale.buyTokens()`, `uint256 quantity = (msg.value * tierToRates[currentTier]).div(1 ether);` should use *SafeMath*
  * [x] Added in [de9ebb3](https://github.com/svandisproject/smart-contract/commit/de9ebb3c6fd3295b1f98abef98f2364c744e4652)
* [x] **LOW IMPORTANCE** In *EIP20Interface*, `pragma solidity ^0.4.19;` while the other 2 files specify `pragma solidity ^0.4.21;`
  * [x] Updated in [de9ebb3](https://github.com/svandisproject/smart-contract/commit/de9ebb3c6fd3295b1f98abef98f2364c744e4652)
* [x] **LOW IMPORTANCE** In *Svandis*, `uint256 constant public totalSupply = 400000000000000000000000000;` better expressed as `uint256 constant public totalSupply = 400000000 * 10**uint256(decimals)` and swap the line position with `uint8 constant public decimals = 18;`
  * [x] Updated in [de9ebb3](https://github.com/svandisproject/smart-contract/commit/de9ebb3c6fd3295b1f98abef98f2364c744e4652)
* [x] **LOW IMPORTANCE** In *Svandis*, there should be some consistency with keywords, and their order
  * [x] `uint256 constant private MAX_UINT256 = 2**256 - 1;` should be rearranged to be `private constant`
    * [x] Updated in [de9ebb3](https://github.com/svandisproject/smart-contract/commit/de9ebb3c6fd3295b1f98abef98f2364c744e4652)
  * [x] `uint256 constant public totalSupply ...` should be rearranged to be `public constant`
    * [x] Updated in [de9ebb3](https://github.com/svandisproject/smart-contract/commit/de9ebb3c6fd3295b1f98abef98f2364c744e4652)
  * [x] `uint8 constant public decimals = 18;` should be rearranged to be `public constant`
    * [x] Updated in [de9ebb3](https://github.com/svandisproject/smart-contract/commit/de9ebb3c6fd3295b1f98abef98f2364c744e4652)
  * [x] `string public name = 'Svandis';` can be made `public constant`
    * [x] Updated in [de9ebb3](https://github.com/svandisproject/smart-contract/commit/de9ebb3c6fd3295b1f98abef98f2364c744e4652)
  * [x] `string public symbol = 'SVN';` can be made `public constant`
    * [x] Updated in [de9ebb3](https://github.com/svandisproject/smart-contract/commit/de9ebb3c6fd3295b1f98abef98f2364c744e4652)
* [x] **LOW IMPORTANCE** In *Svandis*, reorder the constant and variable declarations to be `symbol`, `name`, `decimals`, blank line, `version`, blank line, `totalSupply`, blank line, `MAX_UINT256`, blank line, `balances`, `allowed`.
  * [x] Updated in [de9ebb3](https://github.com/svandisproject/smart-contract/commit/de9ebb3c6fd3295b1f98abef98f2364c744e4652)
* [x] **LOW IMPORTANCE** *Sale.sol* will not compile with Solc `pragma solidity ^0.4.21` as the `constructor()` keyword is not recognised in this compiler version. Consider changing the minimum compiler version to `^0.4.23` in all the source files
  * [x] Updated in [2a33eab](https://github.com/svandisproject/smart-contract/commit/2a33eab2c3a0abd8f51ce5d9668c595bca9ff7e3)
* [x] **LOW IMPORTANCE** Consider making `Sale.owner`, `Sale.withdrawWallet` and `Sale.enableSale` public as it helps with testing and debugging
  * [x] Updated in [2a33eab](https://github.com/svandisproject/smart-contract/commit/2a33eab2c3a0abd8f51ce5d9668c595bca9ff7e3)
* [x] **LOW IMPORTANCE** The statement `require(_from != address(this));` can be removed from `Svandis.transferFrom(...)`
  * [x] Removed in [2a33eab](https://github.com/svandisproject/smart-contract/commit/2a33eab2c3a0abd8f51ce5d9668c595bca9ff7e3)
* [ ] **LOW IMPORTANCE** Move *.sol into a *contracts* subdirectory
  * Developer decided against this

<br />

<hr />

## Potential Vulnerabilities

No potential vulnerabilities have been identified in the crowdsale/token contract.

<br />

<hr />

## Scope

This audit is into the technical aspects of the crowdsale contracts. The primary aim of this audit is to ensure that funds
contributed to these contracts are not easily attacked or stolen by third parties. The secondary aim of this audit is to
ensure the coded algorithms work as expected. This audit does not guarantee that that the code is bugfree, but intends to
highlight any areas of weaknesses.

<br />

<hr />

## Limitations

This audit makes no statements or warranties about the viability of the Svandis' business proposition, the individuals
involved in this business or the regulatory regime for the business model.

<br />

<hr />

## Due Diligence

As always, potential participants in any crowdsale are encouraged to perform their due diligence on the business proposition
before funding any crowdsales.

Potential participants are also encouraged to only send their funds to the official crowdsale Ethereum address, published on
the crowdsale beneficiary's official communication channel.

Scammers have been publishing phishing address in the forums, twitter and other communication channels, and some go as far as
duplicating crowdsale websites. Potential participants should NOT just click on any links received through these messages.
Scammers have also hacked the crowdsale website to replace the crowdsale contract address with their scam address.
 
Potential participants should also confirm that the verified source code on EtherScan.io for the published crowdsale address
matches the audited source code, and that the deployment parameters are correctly set, including the constant parameters.

<br />

<hr />

## Risks

* There are several configuration parameters in the smart contracts (`withdrawWallet` and `tierToRates`) that need to be set correctly for the sale to operate as expected. These will need to be checked carefully after deployment to ensure that the sale runs smoothly.
  * After deploying the contracts to mainnet and configuring the parameters, I would recommend whitelisting a test account, sending a small amount (e.g. 0.01 ETH) and checking the tokens transferred and that the ETH ends up in the correct withdrawWallet.
* Ethers contributed to the crowdsale/token contract are transferred directly to the crowdsale wallet, and tokens are transferred from the crowdsale/token contract to the contributing account. This reduces the severity of any attacks on the crowdsale/token contract.

<br />

<hr />

## Testing

Details of the testing environment can be found in [test](test).

The following functions were tested using the script [test/01_test1.sh](test/01_test1.sh) with the summary results saved
in [test/test1results.txt](test/test1results.txt) and the detailed output saved in [test/test1output.txt](test/test1output.txt):

* [x] Deploy crowdsale/token contracts
* [x] Set withdraw wallet
* [x] Whitelist addresses
* [x] Set rates for tiers
* [x] Contribute at PreSale rates
* [x] Switch to Tier 1
* [x] Contribute at Tier 1
* [x] Switch to Tier 2
* [x] Transfer company tokens
* [x] `transfer(...)`, `approve(...)` and `transferFrom(...)` tokens
* [x] `transfer(...)`, `approve(...)` and `transferFrom(...)` 0 tokens
* [x] `transfer(...)`, `approve(...)` and `transferFrom(...)` too many tokens

<br />

<hr />

## Code Review

* [x] [code-review/EIP20Interface.md](code-review/EIP20Interface.md)
  * [x] contract EIP20Interface
* [x] [code-review/Svandis.md](code-review/Svandis.md)
  * [x] library SafeMath
  * [x] contract Svandis is EIP20Interface
    * [x] using SafeMath for uint256;
* [x] [code-review/Sale.md](code-review/Sale.md)
  * [x] contract Sale is Svandis
    * [x] using SafeMath for uint256;

<br />

### Excluded - Only Used For Testing

* [../Migrations.sol](../Migrations.sol)

<br />

<br />

(c) BokkyPooBah / Bok Consulting Pty Ltd for Svandis - Jun 2 2018. The MIT Licence.