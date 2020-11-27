tokenhandlermodule = {name: "tokenhandlermodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["tokenhandlermodule"]?  then console.log "[tokenhandlermodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region modules
utl = null
state = null
contractManager = null
ethersHandler = null

#endregion

############################################################
#region internalProperties
balanceCheckerName = "BalanceChecker"

############################################################
#region defaultContracts
defaultContracts = {}
defaultContracts[balanceCheckerName] = 
    addresses: 
        "0x1": "0xb1F8e55c7f64D203C1400B9D8555d050F94aDF39" #mainnet
        #"0x3": #ropsten
        #"0x4": #rinkeby
        #"0x5": #goerli
        #"0x2a": #kovan

#endregion

############################################################
allTokens = new Set()
tokensWithBalance = {}

#endregion

############################################################
tokenhandlermodule.initialize = () ->
    log "tokenhandlermodule.initialize"
    utl = allModules.utilmodule
    state = allModules.statemodule
    contractManager = allModules.contractmanagermodule
    ethersHandler = allModules.ethershandlermodule
    return

############################################################
#region exposedFunctions
tokenhandlermodule.noticeRelevantTokens = (tokens) ->
    log "tokenhandlermodule.noticeRelevantTokens"
    allTokens.add(token) for token in tokens
    return


############################################################
retrieveAllTokenBalances = ->
    method = "balances"
    
    tokens = Array.from(allTokens)
    account = state.load("account")
    users = [account]
    args = [users, tokens]
    
    balances = await ethersHandler.contractCall(balanceCheckerName, method, args)
    for balanceBigNum,i in balances when !balanceBigNum.isZero()
        tokensWithBalance[tokens[i]] = {balanceBigNum}

    # olog tokensWithBalance
    return

registerERC20ContractsForTokens = ->
    log "registerERC20ContractsForTokens"
    chainId = ethersHandler.getChainId()
    
    for address,data of tokensWithBalance
        name = "erc20@"+address
        continue if contractManager.getContract(name)?
        data = {addresses: {}}
        data.addresses[chainId] = address
        data.abi = "erc20"
        await contractManager.addContract(name, data)

    return



retrieveAllTokenData = ->
    log "retrieveAllTokenData"
    await registerERC20ContractsForTokens()
    callData = []

    tokens = Object.keys(tokensWithBalance)

    for address in tokens
        name = "erc20@"+address
        method = "symbol"
        callData.push {name, method}
        
        method = "decimals"
        callData.push {name, method}
    
    responseData = await ethersHandler.multiCall(callData)
    # olog {responseData}
    
    for d,i in responseData by 2
        o = tokensWithBalance[tokens[i/2]]
        o.symbol = responseData[i]
        o.decimals = responseData[i+1]
        o.balance = utl.formatUnits(o.balanceBigNum, o.decimals)

    # olog {tokensWithBalance}
    return

############################################################
tokenhandlermodule.registerContracts = ->
    for name,data of defaultContracts
        await contractManager.addContract(name, data)
    return

tokenhandlermodule.retrieveTokenData = ->
    log "tokenhandlermodule.retrieveTokenData"
    await retrieveAllTokenBalances()
    await retrieveAllTokenData()
    return

tokenhandlermodule.getTokensWithBalance = -> tokensWithBalance

#endregion

module.exports = tokenhandlermodule





# retrieveConverterRegistryAddress = ->
#     if bancorConverterRegistryContract then return
#     address = bancorContractRegistryContract
#     method = "addressOf"
#     args = "0x42616e636f72436f6e7665727465725265676973747279"
#     bancorConverterRegistryContract = await web3Handler.contractCall(address, method, args)
#     olog {bancorConverterRegistryContract}
#     return

# retrieveConvertibleTokens = ->
#     if convertibleTokens then return
#     address = bancorConverterRegistryContract
#     method = "getConvertibleTokens"
#     convertibleTokens = await web3Handler.contractCall(address, method)
#     tokenHandler.noticeRelevantTokens(convertibleTokens)
#     # olog {convertibleTokens}
#     log ""+convertibleTokens.length+" convertible Tokens"
#     return

