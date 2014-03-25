EventEmitter = require('eventemitter').EventEmitter
UrlEvent = require('../../events/url.coffee')

class UrlObserver extends EventEmitter
  EVENT_NAME = "hashchange"
  constructor: (@window) ->

  observe: ->
    @window.addEventListener(EVENT_NAME, @_onChange, true)

  disconnect: ->
    @window.removeEventListener(EVENT_NAME, @_onChange, true)

  _onChange: (event) =>
    @emit('urlChanged', new UrlEvent(event.oldURL, event.newURL, event.timeStamp))


module.exports = UrlObserver
