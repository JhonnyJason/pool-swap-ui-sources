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

mustache = require("mustache")
popupHandle = null
tokenHandler = null

############################################################
sourcesectionmodule.initialize = () ->
    log "sourcesectionmodule.initialize"
    tokenHandler = allModules.tokenhandlermodule
    popupHandle = allModules.popupmodule
    addWalletTokenButton.addEventListener("click", addWalletTokenButtonClicked)
    addLiquidityPoolButton.addEventListener("click", addLiquidityPoolButtonClicked)
    return
    
############################################################
#region internalFunctions
selectSourceToken = (evt) ->
    log "selectSourceToken"
    element = evt.target
    tokenAddress = element.getAttribute("address")
    # olog {tokenAddress}

    element.removeEventListener("click", selectSourceToken)
    element.parentNode.removeChild(element)
    content.appendChild(element)# TODO append to correct container
    ## TODO initialize element

    popupHandle.turnDown()
    return

selectSourcePool = (evt) ->
    log "selectSourcePool"
    element = evt.target
    poolAddress = element.getAttribute("address")
    olog {poolAddress}

    element.removeEventListener("click", selectSourcePool)
    element.parent.removeChild(element)
    content.appendChild(element)# TODO append to correct container
    ## TODO initialize element

    popupHandle.turnDown()
    return

############################################################
addWalletTokenButtonClicked = ->
    log "addWalletTokenButtonClicked"
    tokenViews = tokenHandler.getTokenViews()
    title = "+ Wallet Token"

    popupHandle.showWithContent(tokenViews, title)
    elements = tokenHandler.getTokenElements(popupContent)

    for element in elements
        element.addEventListener("click", selectSourceToken)
    return

addLiquidityPoolButtonClicked = ->
    log "addLiquidityPoolButtonClicked"

    poolList = [
        {
            poolSymbol: "ETHBNT"
            tokenOneSymbol: "ETH"
            tokenOneAmount: 272.232
            tokenTwoSymbol: "BNT"
            tokenTwoAmount: 99999.1233
        },
        {
            poolSymbol: "SWFTBNT"
            tokenOneSymbol: "SWFT"
            tokenOneAmount: 1651.232
            tokenTwoSymbol: "BNT"
            tokenTwoAmount: 1912651.1233
        },
        {
            poolSymbol: "JJTBNT"
            tokenOneSymbol: "JJT"
            tokenOneAmount: 17892
            tokenTwoSymbol: "BNT"
            tokenTwoAmount: 982632.228
        },
        {
            poolSymbol: "OMGBNT"
            tokenOneSymbol: "OMG"
            tokenOneAmount: 0.1
            tokenTwoSymbol: "BNT"
            tokenTwoAmount: 20.0
        },
        {
            poolSymbol: "FLOTUNI"
            tokenOneSymbol: "FLOT"
            tokenOneAmount: 272.232
            tokenTwoSymbol: "UNI"
            tokenTwoAmount: 99999.1233
        },
        {
            poolSymbol: "ETHBNT"
            tokenOneSymbol: "ETH"
            tokenOneAmount: 272.232
            tokenTwoSymbol: "BNT"
            tokenTwoAmount: 99999.1233
        },
        {
            poolSymbol: "SWFTBNT"
            tokenOneSymbol: "SWFT"
            tokenOneAmount: 1651.232
            tokenTwoSymbol: "BNT"
            tokenTwoAmount: 1912651.1233
        },
        {
            poolSymbol: "JJTBNT"
            tokenOneSymbol: "JJT"
            tokenOneAmount: 17892
            tokenTwoSymbol: "BNT"
            tokenTwoAmount: 982632.228
        },
        {
            poolSymbol: "OMGBNT"
            tokenOneSymbol: "OMG"
            tokenOneAmount: 0.1
            tokenTwoSymbol: "BNT"
            tokenTwoAmount: 20.0
        },
        {
            poolSymbol: "FLOTUNI"
            tokenOneSymbol: "FLOT"
            tokenOneAmount: 272.232
            tokenTwoSymbol: "UNI"
            tokenTwoAmount: 99999.1233
        }
    ]

    template = hiddenPoolTemplate.innerHTML
    
    content = ""

    for pool in poolList
        content += mustache.render(template, pool)

    title = "+ Liquidity Pool"
    popupHandle.showWithContent(content, title)
    return

#endregion

module.exports = sourcesectionmodule