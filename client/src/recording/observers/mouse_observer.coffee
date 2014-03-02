EventEmitter = require('eventemitter').EventEmitter

class MouseObserver extends EventEmitter
  initialize: (@element)->
    @emit("initialize", [x: 0, y: 0, timestamp: new Date().getTime()])
    @eventHandler = (event) => @_onChange(event)

  observe: ->
    @element.addEventListener('mousemove', @eventHandler, false)

  disconnect: ->
    @element.removeEventListener('mousemove', @eventHandler, false)

  _onChange: (event)=>
    x = event.clientX
    y = event.clientY
    @emit('mouse_moved', [{x: x, y:y, timestamp: event.timeStamp}])

module.exports = MouseObserver
