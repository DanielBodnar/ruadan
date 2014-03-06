EventEmitter = require('eventemitter').EventEmitter

infoToJson = (oldURL, newURL, timestamp)->
  oldURL: oldURL
  newURL: newURL
  timestamp: timestamp

class UrlObserver extends EventEmitter
  EVENT_NAME = "hashchange"
  initialize: (@window) ->
    @emit("initialize", [infoToJson(null, @window.location.href, Date.now())])

  observe: ->
    @window.addEventListener(EVENT_NAME, @_onChange, true)

  disconnect: ->
    @window.removeEventListener(EVENT_NAME, @_onChange, true)

  _onChange: (event) =>
    @emit('urlChanged', [infoToJson(event.oldURL, event.newURL, event.timestamp)])


module.exports = UrlObserver
