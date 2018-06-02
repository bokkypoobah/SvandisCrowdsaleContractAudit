# Sale

Source file [../../contracts/Sale.sol](../../contracts/Sale.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.23;

// BK Ok
import "./Svandis.sol";

// BK Ok
contract Sale is Svandis {
    // BK Ok
    using SafeMath for uint256;

    // BK Next 2 Ok
    address public owner;
    address public withdrawWallet;
    // BK Next 3 Ok
    bool public tiersSet = false;
    uint8 public currentTier = 0;
    bool public enableSale = true;
    // BK Next 3 Ok
    mapping(uint8 => uint256) public tierToRates;
    mapping (address => uint256) public companyAllowed;
    mapping (address => uint256) public contributorAllowed;
    
    // BK Ok - Constructor
    constructor() public {
        // BK Ok
        owner = msg.sender;
        // BK Ok
        balances[this] = totalSupply;
    }
    
    // BK Ok - Modifier
    modifier onlyOwner {
        // BK Ok
        require(owner == msg.sender);
        // BK Ok
        _;
    }

    // BK Ok - Modifier
    modifier onlyWithdrawWallet {
        // BK Ok
        require(withdrawWallet == msg.sender);
        // BK Ok
        _;
    }

    // BK Ok - Modifier
    modifier saleOngoing {
        // BK Ok
        require(enableSale == true);
        // BK Ok
        _;   
    }

    // BK Ok - Only owner can execute
    function setWithdrawWallet(address _withdrawalAddress) public onlyOwner returns (bool success) {
        // BK Ok
        require (_withdrawalAddress != address(0));
        // BK Ok
        withdrawWallet = _withdrawalAddress;
        // BK Ok
        return true;
    }

    //Finalize taking tokens
    // BK Ok - Only owner can execute
    function disableSale() public onlyOwner returns (bool success){
        // BK Ok
        enableSale = false;
        // BK Ok
        return true;
    }

    // BK Ok - View function
    function getContractEth() public view onlyOwner returns (uint256 value) {
        // BK Ok
        return address(this).balance;
    }

    // BK Ok - Only withdrawWallet can execute
    function withdraw(uint256 _amount) public onlyWithdrawWallet returns (bool success){
        // BK Ok
        require(_amount <= address(this).balance);
        // BK Ok
        withdrawWallet.transfer(_amount);
        // BK Ok
        return true;
    }
    
    // BK Ok - Only owner can execute
    function addToWhitelist(address _whitelisted, uint256 _quantity) public onlyOwner returns (bool success) {
        // BK Ok
        require(_quantity <= balances[this]);
        // BK Ok
        contributorAllowed[_whitelisted] = _quantity;
        // BK Ok
        return true;
    }

    // BK Ok - Only owner can execute
    function addMultipleToWhitelist(address[] _whitelistedAddresses, uint256[] _quantities) public onlyOwner returns (bool success) {
        // BK Ok
        require(_whitelistedAddresses.length == _quantities.length);
    // BK Ok
	require(_whitelistedAddresses.length <= 100); //Limit set at 100
	    // BK Ok
        for(uint i = 0; i < _whitelistedAddresses.length; i++) {
            // BK Ok
            addToWhitelist(_whitelistedAddresses[i], _quantities[i]);
        }
    // BK Ok
	return true;
    }

    // BK Ok - Only owner can execute
    function addToCompanyWhitelist(address _whitelisted, uint256 _quantity) public onlyOwner returns (bool success) {
        // BK Ok
        require(_quantity < balances[this]);
        // BK Ok
        companyAllowed[_whitelisted] = _quantity;
        // BK Ok
        return true;
    }
    
    // BK Ok - Only owner can execute
    function removeFromWhitelist(address _whitelisted) public onlyOwner returns (bool success) {
        // BK Ok
        contributorAllowed[_whitelisted] = 0;
        // BK Ok
        return true;
    }

    // BK Ok - Only owner can execute
    function removeFromCompanyWhitelist(address _whitelisted) public onlyOwner returns (bool success) {
        // BK Ok
        companyAllowed[_whitelisted] = 0;
        // BK Ok
        return true;
    }

    // BK Ok - View function
    function checkWhitelisted(address _whitelisted) public view onlyOwner returns (uint256 quantity) {
        // BK Ok
        return contributorAllowed[_whitelisted];
    }

    // BK Ok - View function
    function checkCompanyWhitelisted(address _whitelisted) public view onlyOwner returns (uint256 quantity) {
        // BK Ok
        return companyAllowed[_whitelisted];
    }

    // BK Ok - Only owner can execute
    function setPreSaleRate(uint256 _preSaleRate) public onlyOwner returns (bool success) {
        // BK Ok
        tierToRates[0] = _preSaleRate;
        // BK Ok
        return true;
    }

    // BK Ok - Only owner can execute
    function setTiers(uint256 _tier1Rate, uint256 _tier2Rate) public onlyOwner saleOngoing returns (bool success) {
        // BK Ok
        tiersSet = true;
        // BK Next 2 Ok
        tierToRates[1] = _tier1Rate;
        tierToRates[2] = _tier2Rate;
        // BK Ok
        return true;
    }

    // BK Ok - Only owner can execute
    function switchTiers(uint8 _tier) public onlyOwner returns (bool success) {
        // BK Ok
        require(_tier == 1 || _tier == 2);
        // BK Ok
        require(_tier > currentTier);
        // BK Ok
        currentTier = _tier;
        // BK Ok
        return true;
    }

    // BK Ok - Fallback function will reject any ETH sent
    function () public payable {
        revert();
    }

    // BK Ok - Any whitelisted account can send contribution
    function buyTokens() public saleOngoing payable {
        // BK Ok
        uint256 quantity = (msg.value.mul(tierToRates[currentTier])).div(1 ether);
        // BK Ok
        require(quantity <= contributorAllowed[msg.sender]);

        // BK Next 2 Ok
        balances[msg.sender] = balances[msg.sender].add(quantity);
        balances[address(this)] = balances[address(this)].sub(quantity);
        // BK Ok
        contributorAllowed[msg.sender] = contributorAllowed[msg.sender].sub(quantity);

        // BK Ok
        withdrawWallet.transfer(msg.value);
        // BK Ok - Log event
        emit Transfer(this, msg.sender, quantity);
    }

    // BK Ok - Any whitelisted account can execute
    function takeCompanyTokensOwnership() public {
        // BK Ok
        balances[msg.sender] = balances[msg.sender].add(companyAllowed[msg.sender]);
        // BK Ok
        balances[address(this)] = balances[address(this)].sub(companyAllowed[msg.sender]);

        // BK Ok - Log event
        emit Transfer(this, msg.sender, companyAllowed[msg.sender]);
        // BK Ok
        companyAllowed[msg.sender] = 0;
    }

    // BK Ok - Only owner can execute
    function transferAnyEIP20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        // BK Ok
        return EIP20Interface(tokenAddress).transfer(owner, tokens);
    }
}

```
