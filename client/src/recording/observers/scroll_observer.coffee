EventEmitter = require('eventemitter').EventEmitter
_ = require('lodash')

toJson= (x, y, timestamp) ->
  x: x
  y: y
  timestamp: timestamp

class ScrollObserver extends EventEmitter
  initialize: (@element) ->
    @emit("initialize", [
      toJson(@element.scrollX, @element.scrollY, Date.now())
    ])

    @_throttledOnChange = _.throttle(@_onChange, 100)

  observe: ->
    @element.addEventListener('scroll', @_throttledOnChange, false)

  disconnect: ->
    @element.removeEventListener('scroll', @_throttledOnChange, false)

  _onChange: (event) =>
    @emit('scroll', [toJson(@element.scrollX, @element.scrollY, event.timeStamp)])



module.exports = ScrollObserver
