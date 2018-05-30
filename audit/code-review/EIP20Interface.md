# EIP20Interface

Source file [../../EIP20Interface.sol](../../EIP20Interface.sol).

<br />

<hr />

```javascript
// Abstract contract for the full ERC 20 Token standard
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
// BK NOTE - Other files in this repository specify `pragma solidity ^0.4.21;`
// BK Ok
pragma solidity ^0.4.19;

// BK Ok
contract EIP20Interface {
    // BK Ok
    uint256 public totalSupply;
    // BK Next 5 Ok
    function balanceOf(address _owner) public view returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);
    
    // BK Next 2 Ok - Events
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

```
