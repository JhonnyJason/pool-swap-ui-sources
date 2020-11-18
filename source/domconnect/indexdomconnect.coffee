indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.content = document.getElementById("content")
    global.tokenAmountDisplay = document.getElementById("token-amount-display")
    return
    
module.exports = indexdomconnect