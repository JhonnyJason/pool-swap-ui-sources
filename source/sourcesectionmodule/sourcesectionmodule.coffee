sourcesectionmodule = {name: "sourcesectionmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["sourcesectionmodule"]?  then console.log "[sourcesectionmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

popupHandle = null

############################################################
sourcesectionmodule.initialize = () ->
    log "sourcesectionmodule.initialize"
    popupHandle = allModules.popupmodule
    addWalletTokenButton.addEventListener("click", addWalletTokenButtonClicked)
    addLiquidityPoolButton.addEventListener("click", addLiquidityPoolButtonClicked)
    return
    
addWalletTokenButtonClicked = ->
    log "addWalletTokenButtonClicked"
    content = "Wallet Tokens to choose from<br> asd<br>asd<br>asdd<br>asdasd<br>asasdasd"
    title = "+ Wallet Token"
    popupHandle.showWithContent(content, title)
    return

addLiquidityPoolButtonClicked = ->
    log "addLiquidityPoolButtonClicked"
    content = "Liquidity Pools to choose from"
    title = "+ Liquidity Pool"
    popupHandle.showWithContent(content, title)
    return


module.exports = sourcesectionmodule