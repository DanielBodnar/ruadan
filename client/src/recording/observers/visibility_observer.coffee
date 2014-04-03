EventEmitter = require('eventemitter').EventEmitter
VisibilityEvent = require('../../events/visibility.coffee')

class VisibilityObserver extends EventEmitter
  constructor: (@document) ->

  observe: ->
    @document.addEventListener('webkitvisibilitychange', @_onVisibilityChanged, false)

  disconnect: ->
    @document.removeEventListener('webkitvisibilitychange', @_onVisibilityChanged, false)

  _onVisibilityChanged: =>
    @emit('visibility_changed', new VisibilityEvent(!document.webkitHidden))

module.exports = VisibilityObserver
