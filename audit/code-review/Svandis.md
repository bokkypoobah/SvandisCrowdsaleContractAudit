# Svandis

Source file [../../Svandis.sol](../../Svandis.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.21;

// BK Ok
import "./EIP20Interface.sol";

// BK Ok
library SafeMath {
    // BK Ok - Internal pure function
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // BK Ok
        c = a + b;
        // BK Ok
        require(c >= a);
    }
    // BK Ok - Internal pure function
    function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // BK Ok
        require(b <= a);
        // BK Ok
        c = a - b;
    }
    // BK Ok - Internal pure function
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // BK Ok
        c = a * b;
        // BK Ok
        require(a == 0 || c / a == b);
    }
    // BK Ok - Internal pure function
    function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // BK Ok
        require(b > 0);
        // BK Ok
        c = a / b;
    }
}

// BK Ok
contract Svandis is EIP20Interface {
    // BK Ok
    using SafeMath for uint256;

    // BK Next 3 Ok
    string public constant symbol = 'SVN';
    string public constant name = 'Svandis';
    uint8 public constant decimals = 18;

    // BK Ok
    string public constant version = "SVN 1.0";

    // BK Ok
    uint256 public constant totalSupply = 400000000 * 10**uint256(decimals);

    // BK Ok
    uint256 private constant MAX_UINT256 = 2**256 - 1;

    // BK Next 2 Ok
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;

    // BK Ok - Any account can send tokens
    function transfer(address _to, uint256 _value) public returns (bool success) {
        // BK Ok
        require(balances[msg.sender] >= _value);
        // BK Next 2 Ok
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        // BK Ok - Log event
        emit Transfer(msg.sender, _to, _value);
        // BK Ok
        return true;
    }

    // BK Ok - Any account can send tokens with approval from the `_from` account
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        // BK Ok
        uint256 allowance = allowed[_from][msg.sender];
        // BK Ok
        require(balances[_from] >= _value && allowance >= _value);
        // BK Ok, but can remove
        require(_from != address(this));
        // BK Next 2 Ok
        balances[_to] = balances[_to].add(_value);
        balances[_from] = balances[_from].sub(_value);
        // BK Ok
        if (allowance < MAX_UINT256) {
            // BK Ok
            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        }
        // BK Ok - Log event
        emit Transfer(_from, _to, _value);
        // BK Ok
        return true;
    }

    // BK Ok - View function
    function balanceOf(address _owner) public view returns (uint256 balance) {
        // BK Ok
        return balances[_owner];
    }

    // BK Ok - Any account can approve spending
    function approve(address _spender, uint256 _value) public returns (bool success) {
        // BK Ok
        allowed[msg.sender][_spender] = _value;
        // BK Ok - Log event
        emit Approval(msg.sender, _spender, _value);
        // BK Ok
        return true;
    }

    // BK Ok - View function
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        // BK Ok
        return allowed[_owner][_spender];
    }
}

```
