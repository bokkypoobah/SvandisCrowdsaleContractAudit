# Svandis Crowdsale Contract Audit

Commits
[88b8ac4](https://github.com/svandisproject/smart-contract/commit/88b8ac47747e81f23d7e653affc3614691894845) and
[62d4b53](https://github.com/svandisproject/smart-contract/commit/62d4b53fd32ec6f1c650bfc09890661652dae663).

## Recommendations

* [ ] **LOW IMPORTANCE** In *Sale*, `uint256 public preSaleRate;` is unused
* [ ] **LOW IMPORTANCE** In *Sale.buyTokens()`, `uint256 quantity = (msg.value * tierToRates[currentTier]).div(1 ether);` should use *SafeMath*
* [ ] **LOW IMPORTANCE** Move *.sol into a *contracts* subdirectory

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

* [ ] [code-review/EIP20Interface.md](code-review/EIP20Interface.md)
  * [ ] contract EIP20Interface
* [ ] [code-review/Migrations.md](code-review/Migrations.md)
  * [ ] contract Migrations
* [ ] [code-review/Sale.md](code-review/Sale.md)
  * [ ] contract Sale is Svandis
  * [ ]     using SafeMath for uint256;
* [ ] [code-review/Svandis.md](code-review/Svandis.md)
  * [ ] library SafeMath
  * [ ] contract Svandis is EIP20Interface
  * [ ]     using SafeMath for uint256;


