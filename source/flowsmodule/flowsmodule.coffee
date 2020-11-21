flowsmodule = {name: "flowsmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["flowsmodule"]?  then console.log "[flowsmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
flowsmodule.initialize = () ->
    log "flowsmodule.initialize"
    return
    
module.exports = flowsmodule