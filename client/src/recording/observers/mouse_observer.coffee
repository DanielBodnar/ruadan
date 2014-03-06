EventEmitter = require('eventemitter').EventEmitter
_ = require('lodash')

class MouseObserver extends EventEmitter
  initialize: (@element) ->
    @_throttledOnChange = _.throttle(@_onChange, 100)

  observe: ->
    @element.addEventListener('mouseup', @_onClick, false)
    @element.addEventListener('mousemove', @_throttledOnChange, true)

  disconnect: ->
    @element.removeEventListener('mouseup', @_onClick, false)
    @element.removeEventListener('mousemove', @_throttledOnChange, true)

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
