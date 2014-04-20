_ = require('lodash.custom')
BaseObserver = require('./base_observer.coffee')
MouseClickEvent = require('../../events/mouse/click.coffee')
MousePositionEvent = require('../../events/mouse/position.coffee')

class MouseObserver extends BaseObserver
  EVENTS: {
    MOVED: 'mouse_moved',
    CLICKED: 'mouse_clicked'
  }

  observe: ->
    @window.addEventListener('mouseup', @_onClick, false)
    @window.addEventListener('mousemove', @_onChange, true)

  disconnect: ->
    @window.removeEventListener('mouseup', @_onClick, false)
    @window.removeEventListener('mousemove', @_onChange, true)

  _onClick: (event) =>
    @emit(@EVENTS.CLICKED, new MouseClickEvent(event.clientX, event.clientY, event.which, event.timeStamp))

  _onChange: _.throttle((event) =>
    @emit(@EVENTS.MOVED, new MousePositionEvent(event.clientX, event.clientY, event.timeStamp))
  , 100)

module.exports = MouseObserver
