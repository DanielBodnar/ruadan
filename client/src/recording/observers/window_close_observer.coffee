BaseObserver = require('./base_observer.coffee')
WindowCloseEvent = require('../../events/visibility.coffee')

class WindowCloseObserver extends BaseObserver
  @EVENTS: {
    WINDOW_CLOSED: "window_closed"
  }

  observe: ->
    @window.addEventListener('beforeunload', @_onUnload, false)

  disconnect: ->
    @window.removeEventListener('beforeunload', @_onUnload, false)

  _onUnload: =>
    @emit(@constructor.EVENTS.WINDOW_CLOSED, new WindowCloseEvent())
    null # prevents dialog box from opening

module.exports = WindowCloseObserver
