define([
  'lodash'
  'eventEmitter'
], (
  _
  EventEmitter
)->
  class MouseObserver extends EventEmitter
    initialize: (@element)->
      @trigger("initialize", [x: 0, y: 0, timestamp: new Date().getTime()])

    observe: ->
      @_listener = @element.addEventListener('mousemove', @_onChange.bind(@), false)

    disconnect: ->
      @element.removeEventListener('mousemove', @_onChange.bind(@), false)

    _onChange: _.throttle(((event)->
      x = event.clientX
      y = event.clientY
      @trigger('mouse_moved', [{x: x, y:y, timestamp: event.timeStamp}])
    ), 100)
)
