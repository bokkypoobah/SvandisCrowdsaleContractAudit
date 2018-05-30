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
    // BK Ok - NOTE - Better to leave a blank line after this line
    using SafeMath for uint256;
    // BK Ok - NOTE - Better to reorder the keywords as `private constant`
    uint256 constant private MAX_UINT256 = 2**256 - 1;
    // BK Ok - NOTE - Better to specify as 400000000 * 10**uint256(decimals), and reorder the keywords as `public constant`
    uint256 constant public totalSupply = 400000000000000000000000000;
    // BK Ok - NOTE - Better to switch line position with the previous line, and reorder the keywords as `public constant`
    uint8 constant public decimals = 18;

    // BK Ok
    mapping (address => uint256) public balances;
    // BK Ok
    mapping (address => mapping (address => uint256)) public allowed;
    
    // BK Ok - NOTE - Better to move the next 3 lines prior to `MAX_UINT256` line. Make this `public constant`
    string public name = 'Svandis';
    // BK Ok - NOTE - Better to make this `public constant` 
    string public symbol = 'SVN';
    // BK Ok
    string public constant version = "SVN 1.0";

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value);
        require(_from != address(this));
        balances[_to] = balances[_to].add(_value);
        balances[_from] = balances[_from].sub(_value);
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        }
        emit Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
}

```
