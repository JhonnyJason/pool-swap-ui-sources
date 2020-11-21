popupmodule = {name: "popupmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["popupmodule"]?  then console.log "[popupmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
popupmodule.initialize = () ->
    log "popupmodule.initialize"
    return
    
module.exports = popupmodule