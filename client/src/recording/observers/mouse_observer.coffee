EventEmitter = require('eventemitter').EventEmitter

class MouseObserver extends EventEmitter
  initialize: (@element)->
    @emit("initialize", [x: 0, y: 0, timestamp: new Date().getTime()])

  observe: ->
    @element.addEventListener('mousemove', @_onChange, false)

  disconnect: ->
    @element.removeEventListener('mousemove', @_onChange, false)

  _onChange: (event)=>
    x = event.clientX
    y = event.clientY
    @emit('mouse_moved', [{x: x, y:y, timestamp: event.timeStamp}])

module.exports = MouseObserver