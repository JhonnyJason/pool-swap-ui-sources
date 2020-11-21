abicacheinterface = {}

############################################################
#region checkResponse
extractABI = (response) ->
    if typeof response.jsonABI != "object"
        throw new Error("Unexpected Response: "+response)
    return response.jsonABI

#endregion

############################################################
abicacheinterface.getABI = (address) ->
    authCode = "deadbeef"
    payload = {authCode,address}
    url = "https://abi-cache.extensivlyon.coffee/getABI"
    response = await @postData(url, payload)
    return extractABI(response)


#endregion

    
module.exports = abicacheinterface
