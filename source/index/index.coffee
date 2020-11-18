import Modules from "./allmodules"
import domconnect from "./indexdomconnect"

global.allModules = Modules


window.onload = ->
    domconnect.initialize()
    promises = (m.initialize() for n,m of Modules)
    await Promise.all(promises)
    appStartup()


appStartup = ->
    Modules.appcoremodule.startUp()
    return
