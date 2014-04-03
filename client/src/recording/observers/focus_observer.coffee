EventEmitter = require('eventemitter').EventEmitter
FocusEvent = require('../../events/focus.coffee')

class FocusObserver extends EventEmitter
  constructor: (@window) ->

  observe: ->
    @window.addEventListener('focus', @_onFocus, false)
    @window.addEventListener('blur', @_onBlur, false)

  disconnect: ->
    @window.removeEventListener('focus', @_onFocus, false)
    @window.removeEventListener('blur', @_onBlur, false)

  _onFocus: =>
    @emit('focus_changed', new FocusEvent(true))

  _onBlur: =>
    @emit('focus_changed', new FocusEvent(false))

module.exports = FocusObserver
