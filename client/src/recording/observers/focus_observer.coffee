EventEmitter = require('eventemitter').EventEmitter
FocusEvent = require('../../events/focus.coffee')

class FocusObserver extends EventEmitter
  constructor: (@window) ->

  FOCUS_EVENT: "focus_changed"

  observe: ->
    @window.addEventListener('focus', @_onFocus, false)
    @window.addEventListener('blur', @_onBlur, false)

  disconnect: ->
    @window.removeEventListener('focus', @_onFocus, false)
    @window.removeEventListener('blur', @_onBlur, false)

  _onFocus: =>
    @emit(@FOCUS_EVENT, new FocusEvent(true))

  _onBlur: =>
    @emit(@FOCUS_EVENT, new FocusEvent(false))

module.exports = FocusObserver
