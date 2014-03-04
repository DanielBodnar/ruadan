EventEmitter = require('eventemitter').EventEmitter

class MouseObserver extends EventEmitter
  initialize: (@element) ->
    @emit("initialize", [
      x: 0, y: 0, timestamp: new Date().getTime()
    ])

  observe: ->
    @element.addEventListener('mouseup', @_onClick, false)
    @element.addEventListener('mousemove', @_onChange, false)

  disconnect: ->
    @element.removeEventListener('mouseup', @_onClick, false)
    @element.removeEventListener('mousemove', @_onChange, false)

  _onClick: (event) =>
    eventData =
      x: event.clientX
      y: event.clientY
      timestamp: event.timeStamp
      whichButton: event.which
      type: 'mouseclick'
    @emit('mouse_clicked', [eventData])

  _onChange: (event) =>
    eventData =
      x: event.clientX
      y: event.clientY
      timestamp: event.timeStamp
      type: 'mousemove'
    @emit('mouse_moved', [eventData])


module.exports = MouseObserver
