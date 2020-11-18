walletmanagementmodule = {name: "walletmanagementmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["walletmanagementmodule"]?  then console.log "[walletmanagementmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
web3Handler = null
content = null

############################################################
walletmanagementmodule.initialize = () ->
    log "walletmanagementmodule.initialize"
    web3Handler = allModules.web3handlermodule
    content = allModules.contentmodule
    return

walletmanagementmodule.checkConnection = ->
    log "walletmanagementmodule.checkConnection"
    isConnected = await web3.isConnected()
    olog {isConnected}

    if window.ethereum
        await window.ethereum.enable() ## important to await here ;-)
        isConnected = web3.isConnected()
        olog {isConnected}
        await web3Handler.printAccounts()
        ETHbalance = await web3Handler.getETHBalance()
        olog {ETHbalance}
        # BNTBalance = await web3Handler.getBNTBalance()
        # content.setAmount(BNTBalance)
        COTBalance = await web3Handler.getCOTBalance()
        content.setAmount(COTBalance)
        return true

    return false
    
export default walletmanagementmodule