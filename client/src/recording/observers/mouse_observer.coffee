_ = require('lodash.custom')
BaseObserver = require('./base_observer.coffee')
MouseClickEvent = require('../../events/mouse/click.coffee')
MousePositionEvent = require('../../events/mouse/position.coffee')

class MouseObserver extends BaseObserver
  @EVENTS: {
    MOVED: 'mouse_moved',
    CLICKED: 'mouse_clicked'
  }

  observe: ->
    @_throttledOnChange = _.throttle(@_onChange, 100)
    @window.addEventListener('mouseup', @_onClick, false)
    @window.addEventListener('mousemove', @_throttledOnChange, true)

  disconnect: ->
    @window.removeEventListener('mouseup', @_onClick, false)
    @window.removeEventListener('mousemove', @_throttledOnChange, true)

  _onClick: (event) =>
    @emit(@constructor.EVENTS.CLICKED, new MouseClickEvent(event.clientX, event.clientY, event.which, event.timeStamp))

  _onChange: (event) =>
    @emit(@constructor.EVENTS.MOVED, new MousePositionEvent(event.clientX, event.clientY, event.timeStamp))

module.exports = MouseObserver
