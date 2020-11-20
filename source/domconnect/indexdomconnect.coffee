indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.content = document.getElementById("content")
    global.tokenAmountDisplay = document.getElementById("token-amount-display")
    global.connectWalletButton = document.getElementById("connect-wallet-button")
    return
    
module.exports = indexdomconnect