EventEmitter = require('eventemitter').EventEmitter
WindowCloseEvent = require('../../events/visibility.coffee')

class WindowCloseObserver extends EventEmitter
  constructor: (@window) ->

  observe: ->
    @window.addEventListener('beforeunload', @_onUnload, false)

  disconnect: ->
    @window.removeEventListener('beforeunload', @_onUnload, false)

  _onUnload: =>
    @emit('window_closed', new WindowCloseEvent())
    null # prevents dialog box from opening

module.exports = WindowCloseObserver
