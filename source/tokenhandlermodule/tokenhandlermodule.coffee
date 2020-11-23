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
state = null
web3Handler = null

############################################################
#region internalProperties
balanceCheckerContract = "0xb1F8e55c7f64D203C1400B9D8555d050F94aDF39"

############################################################
tokenDataMap = {}

#endregion

############################################################
tokenhandlermodule.initialize = () ->
    log "tokenhandlermodule.initialize"
    state = allModules.statemodule
    web3Handler = allModules.web3handlermodule
    return

############################################################
#region exposedFunctions
tokenhandlermodule.noticeRelevantTokens = (tokens) ->
    log "tokenhandlermodule.noticeRelevantTokens"
    for token in tokens when !tokenDataMap[token]?
        tokenDataMap[token] = {}
    return

############################################################
retrieveAllTokenBalances = ->
    address = balanceCheckerContract
    method = "balances"
    
    tokens = Object.keys(tokenDataMap)
    account = state.load("account")
    users = [account]
    args = [users, tokens]
    
    balances = await web3Handler.contractCall(address, method, args)
    for balance,i in balances
        tokenDataMap[tokens[i]].balance = balance
    return

tokenhandlermodule.retrieveTokenData = ->
    log "tokenhandlermodule.retrieveTokenData"
    await retrieveAllTokenBalances()
    await retreiveAllTokenData()
    return

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

