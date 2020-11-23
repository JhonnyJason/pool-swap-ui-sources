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
abiCache = null
state = null

#endregion

############################################################
#region internalProperties
Contract = null
contractHandleMap = {}

############################################################
web3 = null

#endregion

############################################################
web3handlermodule.providerDetected = false

############################################################
web3handlermodule.initialize = ->
    log "web3handlermodule.initialize"
    network = allModules.networkmodule
    abiCache = allModules.abicachemodule
    state = allModules.statemodule

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

############################################################
getContractHandle = (address) ->
    if contractHandleMap[address]? then return contractHandleMap[address]
    abi = await abiCache.getABI(address)
    contractHandleMap[address] = new Contract(abi, address)
    return contractHandleMap[address]

#endregion

############################################################
#region exposedFunctions
web3handlermodule.getContractHandle = getContractHandle

web3handlermodule.printAccounts = ->
    account = state.load("account")
    accounts = await web3.eth.getAccounts()
    coinbase = await web3.eth.getCoinbase()
    defaultAccount = web3.eth.defaultAccount

    olog {account, accounts, coinbase, defaultAccount}
    return

web3handlermodule.getETHBalance = ->
    account = state.load("account")
    return web3.utils.fromWei(await web3.eth.getBalance(account))

web3handlermodule.getERC20Balance = (tokenAddress) ->
    handle = await getContractHandle(tokenAddress)
    account = state.load("account")
    balance = await handle.methods.balanceOf(account).call()
    dezimals = await handle.methods.decimals().call()
    return balance / (10 ** dezimals)

web3handlermodule.getMultiERC20Balances = (tokenAddresses) ->
    # TODO implement
    throw new Error("Not Implemented Yet!")
    return

web3handlermodule.contractCall = (contract, method, args) ->
    handle = await getContractHandle(contract)
    account = state.load("account")
    if Array.isArray(args)
        return await handle.methods[method](args...).call()
    else if args
        return await handle.methods[method](args).call()
    else
        return await handle.methods[method]().call()
#endregion


export default web3handlermodule
