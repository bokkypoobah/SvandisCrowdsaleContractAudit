# Svandis Crowdsale Contract Audit

Commits
[88b8ac4](https://github.com/svandisproject/smart-contract/commit/88b8ac47747e81f23d7e653affc3614691894845) and
[62d4b53](https://github.com/svandisproject/smart-contract/commit/62d4b53fd32ec6f1c650bfc09890661652dae663).

## Recommendations

* [ ] **LOW IMPORTANCE** In *Sale*, `uint256 public preSaleRate;` is unused
* [ ] **LOW IMPORTANCE** In `Sale.buyTokens()`, `uint256 quantity = (msg.value * tierToRates[currentTier]).div(1 ether);` should use *SafeMath*
* [ ] **LOW IMPORTANCE** Move *.sol into a *contracts* subdirectory
* [ ] **LOW IMPORTANCE** In *EIP20Interface*, `pragma solidity ^0.4.19;` while the other 2 files specify `pragma solidity ^0.4.21;`
* [ ] **LOW IMPORTANCE** In *Svandis*, `uint256 constant public totalSupply = 400000000000000000000000000;` better expressed as `uint256 constant public totalSupply = 400000000 * 10**uint256(decimals)` and swap the line position with `uint8 constant public decimals = 18;`
* [ ] **LOW IMPORTANCE** In *Svandis*, there should be some consistency with keywords, and their order
  * [ ] `uint256 constant private MAX_UINT256 = 2**256 - 1;` should be rearranged to be `private constant`
  * [ ] `uint256 constant public totalSupply ...` should be rearranged to be `public constant`
  * [ ] `uint8 constant public decimals = 18;` should be rearranged to be `public constant`
  * [ ] `string public name = 'Svandis';` can be made `public constant`
  * [ ] `string public symbol = 'SVN';` can be made `public constant`
* [ ] **LOW IMPORTANCE** In *Svandis*, reorder the constant and variable declarations to be `symbol`, `name`, `decimals`, blank line, `version`, blank line, `totalSupply`, blank line, `MAX_UINT256`, blank line, `balances`, `allowed`.

<br />

### Completed

* [x] **MEDIUM IMPORTANCE** For whitelisting, use a separate `whitelist` data structure instead of reusing the `allowed` data structure
* [x] **MEDIUM IMPORTANCE** Use the SafeMath library to prevent overflow and underflows. Sample code in [FixedSupplyToken.sol](https://github.com/bokkypoobah/Tokens/blob/master/contracts/FixedSupplyToken.sol)
* [x] **LOW IMPORTANCE** In *Svandis* `uint256 constant public decimals = 18;` should be of type `uint8`

<br />

<hr />

## Testing

<br />

<hr />

## Code Review

* [x] [code-review/EIP20Interface.md](code-review/EIP20Interface.md)
  * [x] contract EIP20Interface
* [ ] [code-review/Svandis.md](code-review/Svandis.md)
  * [x] library SafeMath
  * [ ] contract Svandis is EIP20Interface
    * [ ] using SafeMath for uint256;
* [ ] [code-review/Sale.md](code-review/Sale.md)
  * [ ] contract Sale is Svandis
    * [ ] using SafeMath for uint256;

<br />

### Excluded - Only Used For Testing

* [../Migrations.sol](../Migrations.sol)
