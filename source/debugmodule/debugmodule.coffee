debugmodule = {name: "debugmodule", uimodule: false}

#####################################################
debugmodule.initialize = () ->
    # console.log "debugmodule.initialize - nothing to do"
    return

debugmodule.modulesToDebug = 
    unbreaker: true
    appcoremodule: true
    # configmodule: true
    headermodule: true
    walletmanagementmodule: true
    web3handlermodule: true

export default debugmodule
