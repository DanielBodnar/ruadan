VisibilityEvent = require('../../events/visibility.coffee')
BaseObserver = require('./base_observer.coffee')


# Detects if tab is visible to user.
# Currently only detects if the tab is the active tab in a window.
# It can't detect if a window is behind another.
class VisibilityObserver extends BaseObserver
  @EVENTS: {
    VISIBILITY: "visibility_changed"
  }

  observe: ->
    @document.addEventListener('webkitvisibilitychange', @_onVisibilityChanged, false)

  disconnect: ->
    @document.removeEventListener('webkitvisibilitychange', @_onVisibilityChanged, false)

  _onVisibilityChanged: =>
    @emit(@constructor.EVENTS.VISIBILITY, new VisibilityEvent(!@document.webkitHidden))

module.exports = VisibilityObserver
