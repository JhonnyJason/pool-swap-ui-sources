web3handlermodule = {name: "web3handlermodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["web3handlermodule"]?  then console.log "[web3handlermodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region modules
import Web3 from "../../../node_modules/web3/dist/web3.min.js"

############################################################
network = null

#endregion

############################################################
#region internalProperties
Contract = null

############################################################
BNTContract = "0x1f573d6fb3f13d689ff844b4ce37794d79a7ff1c"
bancorBNTABI = null

COTContract = "0x5c872500c00565505f3624ab435c222e558e9ff8"
cotraderCOTABI = null

web3 = null

#endregion

############################################################
web3handlermodule.providerDetected = false

############################################################
web3handlermodule.initialize = ->
    log "web3handlermodule.initialize"
    network = allModules.networkmodule
    provider = window.ethereum || window.givenProvider
    if !provider? then return

    initializeWeb3(provider)
    return

############################################################
#region internalFunction
initializeWeb3 = (provider) ->
    log "initializeWeb3"
    web3handlermodule.providerDetected = true

    web3 = new Web3(provider)
    Contract = web3.eth.Contract
    try
        provider.on("connect", web3Connected)
        provider.on("disconnect", web3Disconnected)
    catch err then log err
    return

web3Connected = ->
    log "web3Connected"
    
    return

web3Disconnected = ->
    log "web3Disconnected"
    
    return







retrieveBancorBNTABI = ->
    return if bancorBNTABI?
    bancorBNTABI = await network.getABI(BNTContract)
    # olog {bancorBNTABI}
    return

retrieveCotraderCOTABI = ->
    return if cotraderCOTABI?
    cotraderCOTABI = await network.getABI(COTContract)
    # olog {bancorBNTABI}
    return


#endregion

############################################################
#region exposedFunctions
web3handlermodule.printAccounts = ->
    accounts = await web3.eth.getAccounts()
    coinbase = await web3.eth.getCoinbase()
    defaultAccount = web3.eth.defaultAccount
    olog {accounts, coinbase, defaultAccount}
    return

web3handlermodule.getETHBalance = ->
    accounts = await web3.eth.getAccounts()
    return web3.utils.fromWei(await web3.eth.getBalance(accounts[0]))

web3handlermodule.getBNTBalance = ->
    accounts = await web3.eth.getAccounts()
    await retrieveBancorBNTABI()
    bnt = new Contract(bancorBNTABI, BNTContract)
    # olog {bnt}
    balance = await bnt.methods.balanceOf(accounts[0]).call()
    dezimals = await bnt.methods.decimals().call()
    return balance / (10 ** dezimals)

web3handlermodule.getCOTBalance = ->
    accounts = await web3.eth.getAccounts()
    await retrieveCotraderCOTABI()
    cot = new Contract(cotraderCOTABI, COTContract)
    # olog {bnt}
    balance = await cot.methods.balanceOf(accounts[0]).call()
    dezimals = await cot.methods.decimals().call()
    return balance / (10 ** dezimals)

#endregion


export default web3handlermodule
