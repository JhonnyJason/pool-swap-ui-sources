contractmanagermodule = {name: "contractmanagermodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["contractmanagermodule"]?  then console.log "[contractmanagermodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region modules
abiCache = null
state = null

genericABIs = require("./genericABIs")
#endregion

############################################################
#region internalProperties


contractLibrary = {}
        
#endregion

############################################################
contractmanagermodule.initialize = ->
    log "contractmanagermodule.initialize"
    abiCache = allModules.abicachemodule
    state = allModules.statemodul
    return
    
############################################################
#region exposedFunctions
contractmanagermodule.addContract = (name, data) ->
    log "contractmanagermodule.addContract"
    # log name
    # olog data

    genericName = null
    if typeof data.abi == "string"
        genericName = data.abi
        data.abi = genericABIs[data.abi]

    mainAddress = data.addresses["0x1"]
    if !data.abi? 
        data.abi = await abiCache.getABI(mainAddress)
        if genericName? then genericABIs[genericName] = data.abi
    
    # when we did not have the generic ABI ready but specified one by name then we would save the retrieved abi as that generic one

    contractLibrary[name] = data
    return

############################################################
contractmanagermodule.getContract = (name) -> contractLibrary[name]

#endregion

module.exports = contractmanagermodule