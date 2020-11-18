footermodule = {name: "footermodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["footermodule"]?  then console.log "[footermodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
footermodule.initialize = () ->
    log "footermodule.initialize"
    return
    
module.exports = footermodule