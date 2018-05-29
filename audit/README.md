# Svandis Crowdsale Contract Audit

Commit [88b8ac4](https://github.com/svandisproject/smart-contract/commit/88b8ac47747e81f23d7e653affc3614691894845).

## Recommendations

* [ ] **MEDIUM IMPORTANCE** For whitelisting, use a separate `whitelist` data structure instead of reusing the `allowed` data structure
* [ ] **MEDIUM IMPORTANCE** Use the SafeMath library to prevent overflow and underflows. Sample code in [FixedSupplyToken.sol](https://github.com/bokkypoobah/Tokens/blob/master/contracts/FixedSupplyToken.sol)
* [ ] **LOW IMPORTANCE** In *Svandis* `uint256 constant public decimals = 18;` should be of type `uint8`
* [ ] **LOW IMPORTANCE** Move *.sol into a *contracts* subdirectory

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
* [ ] [code-review/Svandis.md](code-review/Svandis.md)
  * [ ] contract Svandis is EIP20Interface

