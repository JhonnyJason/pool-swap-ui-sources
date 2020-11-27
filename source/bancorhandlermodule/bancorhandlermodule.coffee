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
contractManager = null
ethersHandler = null
tokenHandler = null
network = null
utl = null

#endregion

############################################################
#region internalProperties
converterRegistryName = "BancorConverterRegistry"
contractRegistryName = "BancorContractRegistry"

############################################################
#region defaultContracts
defaultContracts = {}
defaultContracts[contractRegistryName] = 
    addresses: 
        "0x1": "0x52Ae12ABe5D8BD778BD5397F99cA900624CfADD4" #mainnet
        "0x3": "0xFD95E724962fCfC269010A0c6700Aa09D5de3074" #ropsten
        #"0x4": #rinkeby
        #"0x5": #goerli
        #"0x2a": #kovan

defaultContracts["BNT"] = 
    addresses: 
        "0x1": "0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C" #mainnet
        "0x3": "0xF35cCfbcE1228014F66809EDaFCDB836BFE388f5" #ropsten
        #"0x4": #rinkeby
        #"0x5": #goerli
        #"0x2a": #kovan
    abi: "erc20"

#endregion

############################################################


convertibleTokens = null
liquidityPools = null

#endregion

############################################################
bancorhandlermodule.initialize = () ->
    log "bancorhandlermodule.initialize"
    utl = allModules.utilmodule
    network = allModules.networkmodule
    ethersHandler = allModules.ethershandlermodule
    contractManager = allModules.contractmanagermodule 
    tokenHandler = allModules.tokenhandlermodule
    return

############################################################
#region internalFunctions
registerConverterRegistryContract = ->
    chainId = ethersHandler.getChainId()
    converterRegistryContract = contractManager.getContract(converterRegistryName)
    if !converterRegistryContract? then converterRegistryContract = {addresses:{}}
    else if converterRegistryContract.addresses[chainId]? then return

    method = "addressOf"
    arg = utl.formatBytes32String(converterRegistryName) 
    
    converterRegistryContractAddress = await ethersHandler.contractCall(contractRegistryName, method, arg)

    converterRegistryContract.addresses[chainId] = converterRegistryContractAddress
    await contractManager.addContract(converterRegistryName, converterRegistryContract)
    return

############################################################
retrieveConvertibleTokens = ->
    if convertibleTokens then return

    method = "getConvertibleTokens"
    convertibleTokens = await ethersHandler.contractCall(converterRegistryName, method)

    tokenHandler.noticeRelevantTokens(convertibleTokens)
    return

retrieveLiquidityPools = ->
    if liquidityPools then return

    method = "getLiquidityPools"
    liquidityPools = await ethersHandler.contractCall(converterRegistryName, method)

    noticeRelevantLiquidityPools()
    return


noticeRelevantLiquidityPools = ->
    log "noticeRelevantLiquidityPools"
    
    return
#endregion

############################################################
#region exposedFunctions
bancorhandlermodule.registerContracts = ->
    for name,data of defaultContracts
        await contractManager.addContract(name, data)
    await registerConverterRegistryContract()
    return


############################################################
bancorhandlermodule.updateConvertibleTokens = ->
    convertibleTokens = null
    await retrieveConvertibleTokens()
    return

bancorhandlermodule.updateLiquidityPools = ->
    liquidityPools = null
    await retrieveConvertibleTokens()
    return

############################################################
bancorhandlermodule.retrieveConvertibleTokens = ->
    await retrieveConvertibleTokens()
    return

bancorhandlermodule.retrieveLiquidityPools = ->
    await retrieveLiquidityPools()
    return

#endregion

module.exports = bancorhandlermodule