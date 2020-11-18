sourcesectionmodule = {name: "sourcesectionmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["sourcesectionmodule"]?  then console.log "[sourcesectionmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
sourcesectionmodule.initialize = () ->
    log "sourcesectionmodule.initialize"
    return
    
module.exports = sourcesectionmodule