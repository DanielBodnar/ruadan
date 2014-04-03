_ = require('lodash')
Window = require("./window.coffee")

class Desktop
  constructor: (@document, container) ->
    @_initUI(container)
    @windows = {}

  getWindow: (windowId) ->
    return @windows[windowId] if @windows[windowId]
    @_createWindow(windowId)

  closeAllWindows: ->
    _.values(@windows).forEach( (window) -> window.close() )

  _initUI: (container) ->
    @ui = {
      desktop: @document.createElement("div")
      windowsContainer: @document.createElement("div")
    }
    @ui.desktop.classList.add("desktop")
    @ui.windowsContainer.classList.add("windows_container")
    @ui.desktop.appendChild(@ui.windowsContainer)
    container.appendChild(@ui.desktop)

  _createWindow: (windowId) ->
    newWindow = new Window(@document, @ui.windowsContainer)
    @windows[windowId] = newWindow
    newWindow.on("closed", =>
      delete @windows[windowId]
    )
    newWindow

module.exports = Desktop
