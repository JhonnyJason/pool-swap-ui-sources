protocolselectmodule = {name: "protocolselectmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["protocolselectmodule"]?  then console.log "[protocolselectmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
protocolselectmodule.initialize = () ->
    log "protocolselectmodule.initialize"
    return
    
module.exports = protocolselectmodule