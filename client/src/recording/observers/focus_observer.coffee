BaseObserver = require('./base_observer.coffee')
FocusEvent = require('../../events/focus.coffee')

class FocusObserver extends BaseObserver
  @EVENTS: {
    FOCUS_CHANGED: "focus_changed"
  }

  observe: ->
    @window.addEventListener('focus', @_onFocus, false)
    @window.addEventListener('blur', @_onBlur, false)

  disconnect: ->
    @window.removeEventListener('focus', @_onFocus, false)
    @window.removeEventListener('blur', @_onBlur, false)

  _onFocus: =>
    @emit(@constructor.EVENTS.FOCUS_CHANGED, new FocusEvent(true))

  _onBlur: =>
    @emit(@constructor.EVENTS.FOCUS_CHANGED, new FocusEvent(false))

module.exports = FocusObserver
