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
#region modules
import MetaMaskOnboarding from "@metamask/onboarding"

############################################################
ethersHandler = null
state = null

#endregion

############################################################
onboardingHandle = null

############################################################
walletmanagementmodule.initialize = ->
    log "walletmanagementmodule.initialize"
    ethersHandler = allModules.ethershandlermodule
    state = allModules.statemodule
    
    try
        window.ethereum.on("connect", providerConnected)
        window.ethereum.on("disconnect", providerDisconnected)
        window.ethereum.on("chainChanged", onChainChanged)
        window.ethereum.on("accountsChanged", onAccountsChanged)
        window.ethereum.autoRefreshOnNetworkChange = false
    catch err then log err
    return

############################################################
#region internalFunctions
walletIsConnected = ->
    if !ethersHandler.providerDetected then return false
    if window.ethereum and window.ethereum.selectedAddress
        return true
    return false
    
noWalletAvailable = -> !ethersHandler.providerDetected

############################################################
#region enterStateFunctions
enterConnectedState = ->
    log "enterConnectedState"
    onboardingHandle.stopOnboarding() if onboardingHandle?
    account = window.ethereum.selectedAddress
    state.setSilently("walletAvailable", true)
    state.setSilently("account", account)
    state.callOutChange("account")
    return

enterDisconnectedState = ->
    log "enterDisconnectedState"
    onboardingHandle.stopOnboarding() if onboardingHandle?
    # await ethersHandler.printAccounts()
    state.setSilently("walletAvailable", true)
    state.setSilently("account", null)
    state.callOutChange("account")
    return

enterNoMetaMaskState = ->
    log "enterNoMetaMaskState"
    onboardingHandle = new MetaMaskOnboarding() unless onboardingHandle? 
    state.setSilently("walletAvailable", false)
    state.setSilently("account", null)
    state.callOutChange("account")
    return

#endregion

############################################################
#region eventListeners
providerDisconnected = ->
    log "providerDisconnected"
    walletmanagementmodule.checkConnection()
    return

providerConnected = ->
    log "providerConnected"
    walletmanagementmodule.checkConnection()
    return

onChainChanged = ->
    log "onChainChanged"
    window.location.reload()
    # walletmanagementmodule.checkConnection()
    return

onAccountsChanged = ->
    log "onAccountsChanged"
    walletmanagementmodule.checkConnection()
    return

#endregion

#endregion

############################################################
#region exposedFunctions
walletmanagementmodule.startOnboarding = ->
    log "walletmanagementmodule.startOnboarding"
    onboardingHandle.startOnboarding()
    return

walletmanagementmodule.connectWallet = ->
    log "walletmanagementmodule.connectWallet"
    request = 
        method: 'eth_requestAccounts'
    await window.ethereum.request(request)
    return

walletmanagementmodule.checkConnection = ->
    log "walletmanagementmodule.checkConnection"
    if walletIsConnected()
        enterConnectedState()
        return true
    if noWalletAvailable()
        enterNoMetaMaskState()
        return false
    enterDisconnectedState()
    return
    
#endregion

export default walletmanagementmodule