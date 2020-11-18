poolselectmodule = {name: "poolselectmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["poolselectmodule"]?  then console.log "[poolselectmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
poolselectmodule.initialize = () ->
    log "poolselectmodule.initialize"
    return
    
module.exports = poolselectmodule