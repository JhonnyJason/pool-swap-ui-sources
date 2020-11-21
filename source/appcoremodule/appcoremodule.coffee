appcoremodule = {name: "appcoremodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["appcoremodule"]?  then console.log "[appcoremodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region modules
import wallet from "./walletmanagementmodule"
import web3Handler from "./web3handlermodule"

content = null

#endregion

############################################################
appcoremodule.initialize = () ->
    log "appcoremodule.initialize"
    content = allModules.contentmodule
    return
    
############################################################
#region exposedFunctions
appcoremodule.startUp = ->
    log "appcoremodule.startUp"
    if wallet.checkConnection() 
        log "walletConnection works!"

        ETHbalance = await web3Handler.getETHBalance()
        content.setLabel("ETH")
        content.setAmount(ETHbalance)

        # BNTBalance = await web3Handler.getBNTBalance()
        # content.setLabel("BNT")
        # content.setAmount(BNTBalance)
        
        # COTBalance = await web3Handler.getCOTBalance()
        # content.setLabel("COT")
        # content.setAmount(COTBalance)

    else log "walletConnection does not work!"
    return

#endregion

export default appcoremodule