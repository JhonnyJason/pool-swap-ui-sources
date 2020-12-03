popupmodule = {name: "popupmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["popupmodule"]?  then console.log "[popupmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
popupmodule.initialize = () ->
    log "popupmodule.initialize"
    clickCatcher.addEventListener("click", popupmodule.turnDown)
    popupCloseButton.addEventListener("click", popupmodule.turnDown)
    return

############################################################
popupmodule.turnDown = ->
    popup.classList.remove("active")
    clickCatcher.classList.remove("active")
    popupContent.innerHTML = ""
    return

popupmodule.showWithContent = (content, title) ->
    popup.classList.add("active")
    clickCatcher.classList.add("active")
    popupContent.innerHTML = content
    popupTitle.textContent = title
    return


module.exports = popupmodule