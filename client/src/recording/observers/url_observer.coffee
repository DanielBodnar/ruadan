BaseObserver = require('./base_observer.coffee')
UrlEvent = require('../../events/url.coffee')

class UrlObserver extends BaseObserver
  @EVENTS: {
    URL_CHANGED: 'urlChanged'
  }

  observe: ->
    @window.addEventListener('hashchange', @_onChange, true)

  disconnect: ->
    @window.removeEventListener('hashchange', @_onChange, true)

  _onChange: (event) =>
    @emit(@constructor.EVENTS.URL_CHANGED, new UrlEvent(event.oldURL, event.newURL, event.timeStamp))


module.exports = UrlObserver
