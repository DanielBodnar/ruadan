EventEmitter = require('eventemitter').EventEmitter
class ScrollObserver extends EventEmitter
  initialize: (@element)->
    @emit("initialize", [
      x: @element.scrollX, y: @element.scrollY, timestamp: new Date().getTime()
    ])
    @eventHandler = (event) => @_onChange(event)

  observe: ()->
    @element.addEventListener('scroll', @eventHandler, false)

  disconnect: ->
    @element.removeEventListener('scroll', @eventHandler, false)

  _onChange: (event)=>
    x = @element.scrollX
    y = @element.scrollY
    @emit('scroll', [
      {
        x: x,
        y: y,
        timestamp: event.timeStamp}
    ])



module.exports = ScrollObserver
