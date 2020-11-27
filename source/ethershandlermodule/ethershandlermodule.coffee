ethershandlermodule = {name: "ethershandlermodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["ethershandlermodule"]?  then console.log "[ethershandlermodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region modules
ethers = require "../../../node_modules/ethers/dist/ethers.esm.min.js"
ethCall = require "ethcall"
# ethers = require "../../../node_modules/ethers/dist/ethers.umd.min.js"

contractManager = null
wallet = null
abiCache = null
state = null
utl = null

#endregion

############################################################
#region internaProperties
multicallName = "Multicall"

############################################################
#region defaultContracts
defaultContracts = {}
defaultContracts[multicallName] = 
    addresses: 
        "0x1": "0xb1F8e55c7f64D203C1400B9D8555d050F94aDF39" #mainnet
        "0x3": "0x53c43764255c17bd724f74c4ef150724ac50a3ed" #ropsten
        "0x4": "0x42ad527de7d4e9d9d011ac45b31d8551f8fe9821" #rinkeby
        "0x5": "0x77dca2c955b15e9de4dbbcf1246b4b85b651e50e" #goerli
        "0x2a": "0x2cc8688c5f75e365aaeeb4ea8d6a480405a48d2a" #kovan

#endregion

############################################################
ethCallProvider = null
provider = null
network = null
chainId = ""

C = null
mC = null
multicallHandleMap = {}
contractHandleMap = {}
#endregion

############################################################
ethershandlermodule.providerDetected = false

############################################################
ethershandlermodule.initialize = ->
    log "ethershandlermodule.initialize"
    contractManager = allModules.contractmanagermodule
    wallet = allModules.walletmanagementmodule
    abiCache = allModules.abicachemodule
    state = allModules.statemodule
    utl = allModules.utilmodule

    provider = window.ethereum || window.givenProvider
    if !provider? then return

    await initializeEthers(provider)
    
    state.addOnChangeListener("account", reset)
    return

############################################################
#region internalFunctions
initializeEthers = (web3Provider) ->
    log "initializeEthers"
    ethershandlermodule.providerDetected = true

    C = ethers.Contract
    provider = new ethers.providers.Web3Provider(web3Provider)
    network = await provider.getNetwork()
    
    ethCallProvider = new ethCall.Provider()
    ethCallProvider.init(provider)
    mC = ethCall.Contract

    chainId = "0x"+network.chainId.toString(16)
    return
    # signer = provider.getSigner()
    # olog {signer}

    # contractAddress = artifact.networks[network.chainId].address;

    # contractInstance = new ethers.Contract(
    #     contractAddress,
    #     artifact.abi,
    #     provider.getSigner(),
    # );

############################################################
checkSigner = ->
    log "ethershandlermodule.checkSigner"
    signer = provider.getSigner()
    olog {signer}
    return

############################################################
reset = ->
    log "reset"
    contractHandleMap = {}
    # checkSigner()
    return

############################################################
getContractHandle = (name) ->
    log "getContractHandle"
    if contractHandleMap[name]? then return contractHandleMap[name]
    

    contract = contractManager.getContract(name)
    if !contract? then throw new Error("Contract: "+name+" has not been registered!")

    address = contract.addresses[chainId]
    if !address? then throw new Error("Contract: "+name+" did not have an adddress on chain: "+chainId+"!")

    abi = contract.abi
    if !abi? then throw new Error("Contract: "+name+" did not carry an abi!")


    contractHandleMap[name] = new C(address, abi, provider)
    return contractHandleMap[name]


getMulticallHandle = (name) ->
    log "getMulticallHandle"
    if multicallHandleMap[name]? then return multicallHandleMap[name]
    

    contract = contractManager.getContract(name)
    if !contract? then throw new Error("Contract: "+name+" has not been registered!")

    address = contract.addresses[chainId]
    if !address? then throw new Error("Contract: "+name+" did not have an adddress on chain: "+chainId+"!")

    abi = contract.abi
    if !abi? then throw new Error("Contract: "+name+" did not carry an abi!")


    multicallHandleMap[name] = new mC(address, abi)
    return multicallHandleMap[name]
#endregion

############################################################
#region exposedFunctions
ethershandlermodule.getChainId = -> chainId

############################################################
ethershandlermodule.getETHBalance = ->
    # log "ethershandlermodule.getETHBalance"
    account = state.load("account")
    balance = await provider.getBalance(account)
    return utl.formatEther(balance)

ethershandlermodule.getERC20Balance = (name) ->
    # log "ethershandlermodule.getERC20Balance"
    handle = getContractHandle(name)
    account = state.load("account")
    balance = await handle.balanceOf(account)
    decimals = await handle.decimals()
    return utl.formatUnits(balance, decimals)

############################################################
ethershandlermodule.contractCall = (name, method, args) ->
    log "ethershandlermodule.contractCall"
    handle = await getContractHandle(name)
    account = state.load("account")

    if Array.isArray(args)
        return await handle[method](args...)
    else if args
        return await handle[method](args)
    else
        return await handle[method]()
    return

############################################################
ethershandlermodule.multiCall = (callData) ->
    log "ethershandlermodule.multiCall"
    calls = []

    for d in callData
        handle = await getMulticallHandle(d.name) 
        if Array.isArray(d.args)
            calls.push handle[d.method](d.args...)
        else if d.args
            calls.push handle[d.method](d.args)
        else
            calls.push handle[d.method]()

    return await ethCallProvider.all(calls)

ethershandlermodule.contractTransaction = (name, method, args) ->
    log "ethershandlermodule.contractTransaction"
    return


#endregion

module.exports = ethershandlermodule   
# export default ethershandlermodule