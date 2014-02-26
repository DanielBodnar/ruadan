EventEmitter = require('eventEmitter').EventEmitter
class ScrollObserver extends EventEmitter
  initialize: (@element)->
    @emit("initialize", [
      x: @element.scrollX, y: @element.scrollY, timestamp: new Date().getTime()
    ])

  observe: ()->
    @_listener = @element.addEventListener('scroll', @_onChange.bind(@), false)

  disconnect: ->
    @element.removeEventListener('scroll', @_onChange.bind(@), false)

  _onChange: (event)->
    x = @element.scrollX
    y = @element.scrollY
    @emit('scroll', [
      {x: x, y: y, timestamp: event.timeStamp}
    ])



module.exports = ScrollObserver