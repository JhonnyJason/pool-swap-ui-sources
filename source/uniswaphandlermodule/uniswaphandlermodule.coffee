uniswaphandlermodule = {name: "uniswaphandlermodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["uniswaphandlermodule"]?  then console.log "[uniswaphandlermodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
uniswaphandlermodule.initialize = () ->
    log "uniswaphandlermodule.initialize"
    return
    
module.exports = uniswaphandlermodule