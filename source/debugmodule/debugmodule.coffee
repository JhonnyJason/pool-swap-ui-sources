debugmodule = {name: "debugmodule", uimodule: false}

#####################################################
debugmodule.initialize = () ->
    # console.log "debugmodule.initialize - nothing to do"
    return

debugmodule.modulesToDebug = 
    unbreaker: true
    abicachemodule: true
    appcoremodule: true
    bancorhandlermodule: true
    # configmodule: true
    contractmanagermodule: true
    ethershandlermodule: true
    # headermodule: true
    sourcesectionmodule: true
    statemodule: true
    tokenhandlermodule: true
    # walletmanagementmodule: true
    # web3handlermodule: true

export default debugmodule
