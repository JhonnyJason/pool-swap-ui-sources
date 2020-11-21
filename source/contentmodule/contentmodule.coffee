contentmodule = {name: "contentmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["contentmodule"]?  then console.log "[contentmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
contentmodule.initialize = () ->
    log "contentmodule.initialize"
    return

contentmodule.setLabel = (label) ->
    tokenLabel.textContent = label
    return

contentmodule.setAmount = (amount) ->
    tokenAmountDisplay.textContent = amount
    return

module.exports = contentmodule