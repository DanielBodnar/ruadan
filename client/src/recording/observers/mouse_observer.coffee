EventEmitter = require('eventemitter').EventEmitter
_ = require('lodash')
MouseClickEvent = require('../events/mouse/click.coffee')
MousePositionEvent = require('../events/mouse/position.coffee')

class MouseObserver extends EventEmitter
  constructor: (@window) ->
    @_throttledOnChange = _.throttle(@_onChange, 100)

  observe: ->
    @window.addEventListener('mouseup', @_onClick, false)
    @window.addEventListener('mousemove', @_throttledOnChange, true)

  disconnect: ->
    @window.removeEventListener('mouseup', @_onClick, false)
    @window.removeEventListener('mousemove', @_throttledOnChange, true)

  _onClick: (event) =>
    @emit('mouse_clicked', new MouseClickEvent(event.clientX, event.clientY, event.which, event.timeStamp))

  _onChange: (event) =>
    @emit('mouse_moved', new MousePositionEvent(event.clientX, event.clientY, event.timeStamp))

module.exports = MouseObserver
