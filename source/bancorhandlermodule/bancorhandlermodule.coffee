bancorhandlermodule = {name: "bancorhandlermodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["bancorhandlermodule"]?  then console.log "[bancorhandlermodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region Modules
web3Handler = null
network = null
tokenHandler = null

#endregion

############################################################
#region internalProperties
bancorContractRegistryContract = "0x52Ae12ABe5D8BD778BD5397F99cA900624CfADD4"
bancorConverterRegistryContract = ""
BNTContract = "0x1f573d6fb3f13d689ff844b4ce37794d79a7ff1c"

convertibleTokens = null
liquidityPools = null

#endregion

############################################################
bancorhandlermodule.initialize = () ->
    log "bancorhandlermodule.initialize"
    network = allModules.networkmodule
    web3Handler = allModules.web3handlermodule
    tokenHandler = allModules.tokenhandlermodule
    return

############################################################
#region internalFunctions
retrieveConverterRegistryAddress = ->
    if bancorConverterRegistryContract then return
    address = bancorContractRegistryContract
    method = "addressOf"
    args = "0x42616e636f72436f6e7665727465725265676973747279"
    bancorConverterRegistryContract = await web3Handler.contractCall(address, method, args)
    olog {bancorConverterRegistryContract}
    return

retrieveConvertibleTokens = ->
    if convertibleTokens then return
    address = bancorConverterRegistryContract
    method = "getConvertibleTokens"
    convertibleTokens = await web3Handler.contractCall(address, method)
    tokenHandler.noticeRelevantTokens(convertibleTokens)
    # olog {convertibleTokens}
    log ""+convertibleTokens.length+" convertible Tokens"
    return

retrieveLiquidityPools = ->
    if liquidityPools then return
    address = bancorConverterRegistryContract
    method = "getLiquidityPools"
    liquidityPools = await web3Handler.contractCall(address, method)
    # olog {convertibleTokens}
    log ""+liquidityPools.length+" liquidity Pools"
    return

#endregion

############################################################
#region exposedFunctions
bancorhandlermodule.getBNTBalance = -> await web3Handler.getERC20Balance(BNTContract)

bancorhandlermodule.retrieveConvertibleTokens = ->
    await retrieveConverterRegistryAddress()
    await retrieveConvertibleTokens()
    return

bancorhandlermodule.retrieveLiquidityPools = ->
    await retrieveConverterRegistryAddress()
    await retrieveLiquidityPools()
    return

#endregion

module.exports = bancorhandlermodule