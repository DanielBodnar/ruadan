EventEmitter = require('eventemitter').EventEmitter
class ScrollObserver extends EventEmitter
  initialize: (@element) ->
    @emit("initialize", [
      x: @element.scrollX, y: @element.scrollY, timestamp: new Date().getTime()
    ])

  observe: ->
    @element.addEventListener('scroll', @_onChange, false)

  disconnect: ->
    @element.removeEventListener('scroll', @_onChange, false)

  _onChange: (event) =>
    x = @element.scrollX
    y = @element.scrollY
    @emit('scroll', [
      {
        x: x,
        y: y,
        timestamp: event.timeStamp}
    ])



module.exports = ScrollObserver
