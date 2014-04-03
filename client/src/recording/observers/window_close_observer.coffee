EventEmitter = require('eventemitter').EventEmitter
WindowCloseEvent = require('../../events/visibility.coffee')

class WindowCloseObserver extends EventEmitter
  constructor: (@window) ->

  WINDOW_CLOSED_EVENT: "window_closed"

  observe: ->
    @window.addEventListener('beforeunload', @_onUnload, false)

  disconnect: ->
    @window.removeEventListener('beforeunload', @_onUnload, false)

  _onUnload: =>
    @emit(@WINDOW_CLOSED_EVENT, new WindowCloseEvent())
    null # prevents dialog box from opening

module.exports = WindowCloseObserver
