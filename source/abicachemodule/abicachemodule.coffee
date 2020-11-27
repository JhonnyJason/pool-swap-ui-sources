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
state = null

############################################################
addressABIMap = null
cacheEntries = null

maxCacheSize = 0

############################################################
abicachemodule.initialize = ->
    log "abicachemodule.initialize"
    network = allModules.networkmodule
    state = allModules.statemodule
    maxCacheSize = allModules.configmodule.ABICacheSize
    
    cacheEntries = state.load("cacheEntries") || [null]
    addressABIMap = state.load("addressABIMap") || {}
    touchCache(cacheEntries[0])
    return

############################################################
touchCache = (address) ->
    cacheEntries.unshift(address)
    toRemove = cacheEntries[maxCacheSize]
    if typeof toRemove == "string" then delete addressABIMap[toRemove]
    cacheEntries.length = maxCacheSize
    state.saveAll()
    return

############################################################
abicachemodule.getABI = (address) ->
    if addressABIMap[address]? then return addressABIMap[address]
    addressABIMap[address] = await network.getABI(address)
    touchCache(address)
    return addressABIMap[address]

module.exports = abicachemodule