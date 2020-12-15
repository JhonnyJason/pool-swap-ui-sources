headermodule = {name: "headermodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["headermodule"]?  then console.log "[headermodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
state = null
walletHandler = null

############################################################
headermodule.initialize = () ->
    log "headermodule.initialize"
    walletHandler = allModules.walletmanagementmodule
    state = allModules.statemodule
    
    onAccountChanged()
    state.addOnChangeListener("account", onAccountChanged)
    
    connectWalletButton.addEventListener("click", onConnectWalletButtonClicked)
    return


onConnectWalletButtonClicked = ->
    log "onConnectWalletButtonClicked"
    address  = state.get("account")
    if address? then return ## maybe disconnect?
    
    wallet = state.get("walletAvailable")
    if wallet then walletHandler.connectWallet()
    else walletHandler.startOnboarding()
    return

onAccountChanged = ->
    address  = state.get("account")
    if address? 
        connectWalletButton.textContent = address
        connectWalletButton.classList.add("connected")
        return

    connectWalletButton.classList.remove("connected")
    
    wallet = state.get("walletAvailable")
    if wallet then connectWalletButton.textContent = "Connect Wallet"
    else connectWalletButton.textContent = "Install MetaMask"
    return
    
module.exports = headermodule