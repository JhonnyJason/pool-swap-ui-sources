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
tokenhandlermodule.initialize = () ->
    log "tokenhandlermodule.initialize"
    return
    
module.exports = tokenhandlermodule