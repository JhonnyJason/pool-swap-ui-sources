appcoremodule = {name: "appcoremodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["appcoremodule"]?  then console.log "[appcoremodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region modules
wallet = null
ethersHandler = null

content = null
bancorHandler = null
tokenHandler = null

#endregion

############################################################
appcoremodule.initialize = () ->
    log "appcoremodule.initialize"
    wallet = allModules.walletmanagementmodule
    ethersHandler = allModules.ethershandlermodule

    content = allModules.contentmodule
    bancorHandler = allModules.bancorhandlermodule
    tokenHandler = allModules.tokenhandlermodule
    return


registerAllContracts = ->
    log "registerAllContracts"
    promises = (m.registerContracts() for n,m of allModules when m.registerContracts?) 
    await Promise.all(promises)
    return

############################################################
#region exposedFunction
appcoremodule.startUp = ->
    log "appcoremodule.startUp"
    await registerAllContracts()
    wallet.checkConnection()

    await bancorHandler.retrieveConvertibleTokens()
    # await bancorHandler.retrieveLiquidityPools()

    await tokenHandler.retrieveTokenData()
    return

#endregion

export default appcoremodule