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

############################################################
sourcesectionmodule.initialize = () ->
    log "sourcesectionmodule.initialize"
    popupHandle = allModules.popupmodule
    addWalletTokenButton.addEventListener("click", addWalletTokenButtonClicked)
    addLiquidityPoolButton.addEventListener("click", addLiquidityPoolButtonClicked)
    return
    
addWalletTokenButtonClicked = ->
    log "addWalletTokenButtonClicked"

    tokenList = [
        {
            amount: 0.1645272
            symbol: "ETH"
        },
        {
            amount: 10509321.1626123123123123123123123
            symbol: "COT"
        },
        {
            amount: 1717.262162
            symbol: "BNT"
        },
        {
            amount: 555.521323
            symbol: "DAI"
        },
        {
            amount: 8862.2287
            symbol: "JJT"
        }
    ]

    template = hiddenTokenTemplate.innerHTML
    
    content = ""

    cObj = {}
    cObj.tokenAmount = 0
    cObj.tokenSymbol = ""

    for token in tokenList
        cObj.tokenAmount = token.amount
        cObj.tokenSymbol = token.symbol
        content += mustache.render(template, cObj)
    
    title = "+ Wallet Token"
    popupHandle.showWithContent(content, title)
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


module.exports = sourcesectionmodule