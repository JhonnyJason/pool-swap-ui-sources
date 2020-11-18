abicacheinterface = {}

ABIRequest = "https://api.etherscan.io/api?module=contract&action=getabi&address="
etherScanAPIKey = "..."


############################################################
#region checkResponse
digestABIResponse = (response) ->
    digest = JSON.parse(response.result)
    return digest


#endregion

############################################################
abicacheinterface.getABI = (contract) ->
    keyPart = "&apikey="+etherScanAPIKey
    url = ABIRequest+contract+keyPart
    response = await @getData(url)
    digested = digestABIResponse(response)
    return digested


#endregion

    
module.exports = abicacheinterface
