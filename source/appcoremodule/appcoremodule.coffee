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
import wallet from "./walletmanagementmodule"

############################################################
appcoremodule.initialize = () ->
    log "appcoremodule.initialize"
    return
    
############################################################
#region exposedFunctions
appcoremodule.startUp = ->
    log "appcoremodule.startUp"
    if wallet.checkConnection() then log "walletConnection works!"
    else log "walletConnection does not work!"
    return

#endregion

export default appcoremodule