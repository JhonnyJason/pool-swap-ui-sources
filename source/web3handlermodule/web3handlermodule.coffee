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
# import Web3 from "../../../node_modules/web3/dist/web3.min.js"
# MultiCall = require 'eth-multicall'

# import { _makeMulticallData } from "@makerdao/multicall/src/aggregate.js"
# {defaultAbiCoder} = require("@ethersproject/abi");

############################################################
abiCache = null
state = null

#endregion

############################################################
#region internalProperties
ERC20_ABI = [{ 'constant': true, 'inputs': [{ 'name': '_owner', 'type': 'address' }], 'name': 'balanceOf', 'outputs': [{ 'name': 'balance', 'type': 'uint256' }], 'payable': false, 'type': 'function' }]

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

getERC20Handle = (address) -> new Contract(ERC20_ABI, address)

onBatchUpdate = (update) ->
    log "onBatchUpdate"
    olog {updates}
    return

strip0x = (hexContent) -> hexContent.replace(/^0x/, '')

rawResultsToResults = (rawResults, calls) ->

    returnTypeArray = calls.map((el) -> el.returnTypes).flat()
    returnDataMeta = calls.map((el) -> el.returns).flat()

    if returnTypeArray.length != returnTypeArray.length then throw new Error("Malformed callsList!")
    olog {rawResults}

    # decodeParams = 
    # rawResultsDecoded = decodeParams(['uint256', 'bytes[]'], rawResults)
    # rawResultsDecoded = web3.eth.abi.decodeParameters(['uint256', 'bytes[]'], rawResults)
    olog {defaultAbiCoder}
    rawResultsDecoded = defaultAbiCoder.decode(['uint256', 'bytes[]'], rawResults)
    
    olog {rawResultsDecoded}
    # blockNumber = rawResultsDecoded.shift()
    # olog {blockNumber}
    resultsList = rawResultsDecoded[1]
    olog {resultsList}

    for results,idx in resultsList
        types = calls[idx].returnTypes
        resultsDecoded = defaultAbiCoder.decode(types, results)
        olog {resultsDecoded}

    # parsedVals = rawResultsDecoded.reduce(
    #     (acc, r) ->
    #         olog r
    #         r.forEach(
    #             (results, idx) ->
    #                 types = calls[idx].returnTypes
    #                 log types
    #                 resultsDecoded = decodeParams(types, results)
    #                 acc.push(
    #                     ...resultsDecoded.map(
    #                         (r, idx) ->
    #                             if (types[idx] == 'bool') then return r.toString() == 'true'
    #                             return r
    #                     )
    #                 )
    #         )
    #         return acc
    #     , 
    #     []
    # )
    # olog {parsedVals}

    # const retObj = { blockNumber, original: {}, transformed: {} };

    # for (let i = 0; i < parsedVals.length; i++) {
    #     const [name, transform] = returnDataMeta[i];
    #     retObj.original[name] = parsedVals[i];
    #     retObj.transformed[name] = transform !== undefined ? transform(parsedVals[i]) : parsedVals[i];
    # }

    # return { results: retObj, keyToArgMap };
    # }

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
    log "web3handlermodule.getMultiERC20Balances"
    calls = [
        {
            target: "0x960b236A07cf122663c4303350609A66A7B288C0",
            method: 'symbol()',
            returnTypes: ['string'],
            returns: [['Symbol']]
        },
        {
            target: "0x960b236A07cf122663c4303350609A66A7B288C0",
            method: 'decimals()',
            returnTypes: ['uint8'],
            returns: [['Dezimals']]
        }
    ]
    rawData = _makeMulticallData(calls)
    # olog {rawData}
    multicallAddress = "0xeefBa1e63905eF1D7ACbA5a8513c70307C1cE441" #maker dao contract
    AGGREGATE_SELECTOR = '0x252dba42'

    abiEncodedData =  AGGREGATE_SELECTOR + strip0x(rawData);
    handle = await getContractHandle(multicallAddress)


    # result = await handle.methods.aggregate(rawData).call()
    result = await web3.eth.call({
        to: multicallAddress,
        data: abiEncodedData
    });
    # olog {result}
    # rawResultsToResults(strip0x(result), calls)
    rawResultsToResults(result, calls)

    # window.web3 = web3
    # watcher = createWatcher(calls)
    # watcher.batch().subscribe(onBatchUpdate)
    # watcher.start()

    # throw new Error("Not Implemented Yet!")
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
