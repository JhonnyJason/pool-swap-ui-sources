abicachemodule = {name: "abicachemodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["abicachemodule"]?  then console.log "[abicachemodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
network = null

############################################################
addressABIMap = {}

############################################################
abicachemodule.initialize = () ->
    log "abicachemodule.initialize"
    network = allModules.networkmodule
    return

############################################################
abicachemodule.getABI = (address) ->
    if addressABIMap[address]? then return addressABIMap[address]
    addressABIMap[address] = await network.getABI(address)
    return addressABIMap[address]

module.exports = abicachemodule