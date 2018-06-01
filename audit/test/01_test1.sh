#!/bin/bash
# ----------------------------------------------------------------------------------------------
# Testing the smart contract
#
# Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
# ----------------------------------------------------------------------------------------------

MODE=${1:-test}

GETHATTACHPOINT=`grep ^IPCFILE= settings.txt | sed "s/^.*=//"`
PASSWORD=`grep ^PASSWORD= settings.txt | sed "s/^.*=//"`

SOURCEDIR=`grep ^SOURCEDIR= settings.txt | sed "s/^.*=//"`

TOKENSOL=`grep ^TOKENSOL= settings.txt | sed "s/^.*=//"`
TOKENJS=`grep ^TOKENJS= settings.txt | sed "s/^.*=//"`

DEPLOYMENTDATA=`grep ^DEPLOYMENTDATA= settings.txt | sed "s/^.*=//"`

INCLUDEJS=`grep ^INCLUDEJS= settings.txt | sed "s/^.*=//"`
TEST1OUTPUT=`grep ^TEST1OUTPUT= settings.txt | sed "s/^.*=//"`
TEST1RESULTS=`grep ^TEST1RESULTS= settings.txt | sed "s/^.*=//"`

printf "MODE            = '$MODE'\n" | tee $TEST1OUTPUT
printf "GETHATTACHPOINT = '$GETHATTACHPOINT'\n" | tee -a $TEST1OUTPUT
printf "PASSWORD        = '$PASSWORD'\n" | tee -a $TEST1OUTPUT
printf "SOURCEDIR       = '$SOURCEDIR'\n" | tee -a $TEST1OUTPUT
printf "TOKENSOL        = '$TOKENSOL'\n" | tee -a $TEST1OUTPUT
printf "TOKENJS         = '$TOKENJS'\n" | tee -a $TEST1OUTPUT
printf "DEPLOYMENTDATA  = '$DEPLOYMENTDATA'\n" | tee -a $TEST1OUTPUT
printf "INCLUDEJS       = '$INCLUDEJS'\n" | tee -a $TEST1OUTPUT
printf "TEST1OUTPUT     = '$TEST1OUTPUT'\n" | tee -a $TEST1OUTPUT
printf "TEST1RESULTS    = '$TEST1RESULTS'\n" | tee -a $TEST1OUTPUT

# Make copy of SOL file and modify start and end times ---
`cp $SOURCEDIR/*.sol .`

# --- Modify parameters ---
`perl -pi -e "s/address owner;/address public owner;/" Sale.sol`
`perl -pi -e "s/address withdrawWallet;/address public withdrawWallet;/" Sale.sol`
`perl -pi -e "s/bool private enableSale/bool public enableSale/" Sale.sol`

solc_0.4.23 --version | tee -a $TEST1OUTPUT

echo "var tokenOutput=`solc_0.4.23 --optimize --pretty-json --combined-json abi,bin,interface $TOKENSOL`;" > $TOKENJS


geth --verbosity 3 attach $GETHATTACHPOINT << EOF | tee -a $TEST1OUTPUT
loadScript("$TOKENJS");
loadScript("functions.js");

var tokenAbi = JSON.parse(tokenOutput.contracts["$TOKENSOL:Sale"].abi);
var tokenBin = "0x" + tokenOutput.contracts["$TOKENSOL:Sale"].bin;

// console.log("DATA: tokenAbi=" + JSON.stringify(tokenAbi));
// console.log("DATA: tokenBin=" + JSON.stringify(tokenBin));


unlockAccounts("$PASSWORD");
printBalances();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var deployTokenMessage = "Deploy Token Contract";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + deployTokenMessage + " ----------");
var tokenContract = web3.eth.contract(tokenAbi);
var tokenTx = null;
var tokenAddress = null;
var token = tokenContract.new({from: contractOwnerAccount, data: tokenBin, gas: 6000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        tokenTx = contract.transactionHash;
      } else {
        tokenAddress = contract.address;
        addAccount(tokenAddress, "Token '" + token.symbol() + "' '" + token.name() + "'");
        addTokenContractAddressAndAbi(tokenAddress, tokenAbi);
        console.log("DATA: var tokenAddress=\"" + tokenAddress + "\";");
        console.log("DATA: var tokenAbi=" + JSON.stringify(tokenAbi) + ";");
        console.log("DATA: var token=eth.contract(tokenAbi).at(tokenAddress);");
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(tokenTx, deployTokenMessage);
printTxData("tokenAddress=" + tokenAddress, tokenTx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var setWithdrawWalletMessage = "Set Withdraw Wallet";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + setWithdrawWalletMessage + " ----------");
var setWithdrawWallet_1Tx = token.setWithdrawWallet(withdrawWallet, {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(setWithdrawWallet_1Tx, setWithdrawWalletMessage);
printTxData("setWithdrawWallet_1Tx", setWithdrawWallet_1Tx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var whitelistMessage = "Whitelist";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + whitelistMessage + " ----------");
var whitelist_1Tx = token.addToWhitelist(account3, new BigNumber("10000000").shift(18), {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
var whitelist_2Tx = token.addMultipleToWhitelist([account4], [new BigNumber("10000000").shift(18)], {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
var whitelist_3Tx = token.addToCompanyWhitelist(account9, new BigNumber("100000000").shift(18), {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
var whitelist_4Tx = token.addToCompanyWhitelist(account10, new BigNumber("297540000").shift(18), {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(whitelist_1Tx, whitelistMessage + " - addToWhitelist(account3, 10000000 tokens)");
failIfTxStatusError(whitelist_2Tx, whitelistMessage + " - addMultipleToWhitelist([account4], [10000000 tokens])");
failIfTxStatusError(whitelist_3Tx, whitelistMessage + " - addToCompanyWhitelist(account9, 100000000 tokens)");
failIfTxStatusError(whitelist_2Tx, whitelistMessage + " - addToCompanyWhitelist(account10, 200000000 tokens)");
printTxData("whitelist_1Tx", whitelist_1Tx);
printTxData("whitelist_2Tx", whitelist_2Tx);
printTxData("whitelist_3Tx", whitelist_3Tx);
printTxData("whitelist_4Tx", whitelist_4Tx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var setTiersMessage = "Set Tiers";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + setTiersMessage + " ----------");
var setTiers_1Tx = token.setPreSaleRate(new BigNumber(300).shift(18), {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
var setTiers_2Tx = token.setTiers(new BigNumber(200).shift(18), new BigNumber(100).shift(18), {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(setTiers_1Tx, setTiersMessage + " - setPreSaleRate(300)");
failIfTxStatusError(setTiers_2Tx, setTiersMessage + " - setTiers(200, 100)");
printTxData("setTiers_1Tx", setTiers_1Tx);
printTxData("setTiers_2Tx", setTiers_2Tx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var contribute1Message = "Contribute #1 - PreSale";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + contribute1Message + " ----------");
var contribute1_1Tx = token.buyTokens({from: account3, value: web3.toWei(100, "ether"), gas: 400000, gasPrice: defaultGasPrice});
var contribute1_2Tx = token.buyTokens({from: account4, value: web3.toWei(100, "ether"), gas: 400000, gasPrice: defaultGasPrice});
var contribute1_3Tx = token.buyTokens({from: account5, value: web3.toWei(100, "ether"), gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(contribute1_1Tx, contribute1Message + " - ac3 contribute 100 ETH");
failIfTxStatusError(contribute1_2Tx, contribute1Message + " - ac4 contribute 100 ETH");
passIfTxStatusError(contribute1_3Tx, contribute1Message + " - ac5 contribute 100 ETH - Expecting failure as not whitelisted");
printTxData("contribute1_1Tx", contribute1_1Tx);
printTxData("contribute1_2Tx", contribute1_2Tx);
printTxData("contribute1_3Tx", contribute1_3Tx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var switchTiers1Message = "Switch To Tier 1";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + switchTiers1Message + " ----------");
var switchTiers1_1Tx = token.switchTiers(1, {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(switchTiers1_1Tx, switchTiers1Message + " - switchTiers(1)");
printTxData("switchTiers1_1Tx", switchTiers1_1Tx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var contribute2Message = "Contribute #2 - Tier 1";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + contribute2Message + " ----------");
var contribute2_1Tx = token.buyTokens({from: account3, value: web3.toWei(1000, "ether"), gas: 400000, gasPrice: defaultGasPrice});
var contribute2_2Tx = token.buyTokens({from: account4, value: web3.toWei(1000, "ether"), gas: 400000, gasPrice: defaultGasPrice});
var contribute2_3Tx = token.buyTokens({from: account5, value: web3.toWei(1000, "ether"), gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(contribute2_1Tx, contribute2Message + " - ac3 contribute 1000 ETH");
failIfTxStatusError(contribute2_2Tx, contribute2Message + " - ac4 contribute 1000 ETH");
passIfTxStatusError(contribute2_3Tx, contribute2Message + " - ac5 contribute 1000 ETH - Expecting failure as not whitelisted");
printTxData("contribute2_1Tx", contribute2_1Tx);
printTxData("contribute2_2Tx", contribute2_2Tx);
printTxData("contribute2_3Tx", contribute2_3Tx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var switchTiers2Message = "Switch To Tier 2";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + switchTiers2Message + " ----------");
var switchTiers2_1Tx = token.switchTiers(2, {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(switchTiers2_1Tx, switchTiers2Message + " - switchTiers(2)");
printTxData("switchTiers2_1Tx", switchTiers2_1Tx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var contribute3Message = "Contribute #3 - Tier 2";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + contribute3Message + " ----------");
var contribute3_1Tx = token.buyTokens({from: account3, value: web3.toWei(10000, "ether"), gas: 400000, gasPrice: defaultGasPrice});
var contribute3_2Tx = token.buyTokens({from: account4, value: web3.toWei(10000, "ether"), gas: 400000, gasPrice: defaultGasPrice});
var contribute3_3Tx = token.buyTokens({from: account5, value: web3.toWei(10000, "ether"), gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(contribute3_1Tx, contribute3Message + " - ac3 contribute 10000 ETH");
failIfTxStatusError(contribute3_2Tx, contribute3Message + " - ac4 contribute 10000 ETH");
passIfTxStatusError(contribute3_3Tx, contribute3Message + " - ac5 contribute 10000 ETH - Expecting failure as not whitelisted");
printTxData("contribute3_1Tx", contribute3_1Tx);
printTxData("contribute3_2Tx", contribute3_2Tx);
printTxData("contribute3_3Tx", contribute3_3Tx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var takeCompanyTokensMessage = "Company Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + takeCompanyTokensMessage + " ----------");
var takeCompanyTokens_1Tx = token.takeCompanyTokensOwnership({from: account9, gas: 400000, gasPrice: defaultGasPrice});
var takeCompanyTokens_2Tx = token.takeCompanyTokensOwnership({from: account10, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(takeCompanyTokens_1Tx, takeCompanyTokensMessage + " - ac9 takeCompanyTokensOwnership()");
failIfTxStatusError(takeCompanyTokens_2Tx, takeCompanyTokensMessage + " - ac10 takeCompanyTokensOwnership()");
printTxData("takeCompanyTokens_1Tx", takeCompanyTokens_1Tx);
printTxData("takeCompanyTokens_2Tx", takeCompanyTokens_2Tx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var moveTokensMessage = "Move Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + moveTokensMessage + " ----------");
var moveTokens1Tx = token.transfer(account5, new BigNumber("1").shift(18), {from: account3, gas: 100000, gasPrice: defaultGasPrice});
var moveTokens2Tx = token.approve(account6, new BigNumber("2").shift(18), {from: account4, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
var moveTokens3Tx = token.transferFrom(account4, account7, new BigNumber("2").shift(18), {from: account6, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(moveTokens1Tx, moveTokensMessage + " - transfer 1 tokens ac3 -> ac5");
failIfTxStatusError(moveTokens2Tx, moveTokensMessage + " - approve 2 tokens ac4 -> ac6");
failIfTxStatusError(moveTokens3Tx, moveTokensMessage + " - transferFrom 2 tokens ac4 -> ac7 by ac6");
printTxData("moveTokens1Tx", moveTokens1Tx);
printTxData("moveTokens2Tx", moveTokens2Tx);
printTxData("moveTokens3Tx", moveTokens3Tx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var moveZeroTokensMessage = "Move Zero Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + moveZeroTokensMessage + " ----------");
var moveZeroTokens1Tx = token.transfer(account5, 0, {from: account3, gas: 100000, gasPrice: defaultGasPrice});
var moveZeroTokens2Tx = token.approve(account6, 0, {from: account4, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
var moveZeroTokens3Tx = token.transferFrom(account4, account7, 0, {from: account6, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(moveZeroTokens1Tx, moveZeroTokensMessage + " - transfer 0 tokens ac3 -> ac5");
failIfTxStatusError(moveZeroTokens2Tx, moveZeroTokensMessage + " - approve 0 tokens ac4 -> ac6");
failIfTxStatusError(moveZeroTokens3Tx, moveZeroTokensMessage + " - transferFrom 0 tokens ac4 -> ac7 by ac6");
printTxData("moveZeroTokens1Tx", moveZeroTokens1Tx);
printTxData("moveZeroTokens2Tx", moveZeroTokens2Tx);
printTxData("moveZeroTokens3Tx", moveZeroTokens3Tx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var moveTooManyTokensMessage = "Move Too Many Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + moveTooManyTokensMessage + " ----------");
var moveTooManyTokens1Tx = token.transfer(account5, new BigNumber("10000000").shift(18), {from: account3, gas: 100000, gasPrice: defaultGasPrice});
var moveTooManyTokens2Tx = token.approve(account6, new BigNumber("10000000").shift(18), {from: account4, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
var moveTooManyTokens3Tx = token.transferFrom(account4, account7, new BigNumber("10000000").shift(18), {from: account6, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
passIfTxStatusError(moveTooManyTokens1Tx, moveTooManyTokensMessage + " - transfer 10,000,000 tokens ac4 -> ac6 - expecting failure");
failIfTxStatusError(moveTooManyTokens2Tx, moveTooManyTokensMessage + " - approve 10,000,000 tokens ac5 -> ac7");
passIfTxStatusError(moveTooManyTokens3Tx, moveTooManyTokensMessage + " - transferFrom 10,000,000 tokens ac5 -> ac8 by ac7 - expecting failure");
printTxData("moveTooManyTokens1Tx", moveTooManyTokens1Tx);
printTxData("moveTooManyTokens2Tx", moveTooManyTokens2Tx);
printTxData("moveTooManyTokens3Tx", moveTooManyTokens3Tx);
printTokenContractDetails();
console.log("RESULT: ");


EOF
grep "DATA: " $TEST1OUTPUT | sed "s/DATA: //" > $DEPLOYMENTDATA
cat $DEPLOYMENTDATA
grep "RESULT: " $TEST1OUTPUT | sed "s/RESULT: //" > $TEST1RESULTS
cat $TEST1RESULTS
