indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.content = document.getElementById("content")
    global.tokenLabel = document.getElementById("token-label")
    global.tokenAmountDisplay = document.getElementById("token-amount-display")
    global.addWalletTokenButton = document.getElementById("add-wallet-token-button")
    global.addLiquidityPoolButton = document.getElementById("add-liquidity-pool-button")
    global.clickCatcher = document.getElementById("click-catcher")
    global.popup = document.getElementById("popup")
    global.popupTitle = document.getElementById("popup-title")
    global.popupCloseButton = document.getElementById("popup-close-button")
    global.popupContent = document.getElementById("popup-content")
    global.connectWalletButton = document.getElementById("connect-wallet-button")
    return
    
module.exports = indexdomconnect