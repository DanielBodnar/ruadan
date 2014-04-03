EventEmitter = require('eventemitter').EventEmitter
VisibilityEvent = require('../../events/visibility.coffee')

# Detects if tab is visible to user.
# Currently only detects if the tab is the active tab in a window.
# It can't detect if a window is behind another.
class VisibilityObserver extends EventEmitter
  constructor: (@document) ->

  VISIBILITY_EVENT: "visibility_changed"

  observe: ->
    @document.addEventListener('webkitvisibilitychange', @_onVisibilityChanged, false)

  disconnect: ->
    @document.removeEventListener('webkitvisibilitychange', @_onVisibilityChanged, false)

  _onVisibilityChanged: =>
    @emit(@VISIBILITY_EVENT, new VisibilityEvent(!document.webkitHidden))

module.exports = VisibilityObserver
