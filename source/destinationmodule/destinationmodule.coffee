destinationmodule = {name: "destinationmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["destinationmodule"]?  then console.log "[destinationmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
destinationmodule.initialize = () ->
    log "destinationmodule.initialize"
    return
    
module.exports = destinationmodule