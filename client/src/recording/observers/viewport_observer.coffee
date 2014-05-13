_ = require('lodash.custom')
BaseObserver = require('./base_observer.coffee')
ViewportEvent = require('../../events/viewport.coffee')

getWidth= (win) ->
  win.innerWidth

getHeight= (win) ->
  win.innerHeight

class ViewportObserver extends BaseObserver
  @EVENTS: {
    RESIZE: 'resize'
  }

  observe: ->
    @windowX = @windowY = 0
    @window.addEventListener('resize', @_onChange, true)
#WHY DO WE NEED THIS?
#    @interval = setInterval( ( =>
#      newX = @window.screenLeft - @window.screen.availLeft
#      newY = @window.screenTop - @window.screen.availTop
#      if (@windowX != newX || @windowY != newY)
#        @windowX = newX
#        @windowY = newY
#        @_onChange()
#    ), 100)

  disconnect: ->
    @window.removeEventListener('resize', @_debouncedOnChange, true)
#    clearInterval(@interval)

  _onChange: _.debounce((event) =>
    @emit(@constructor.EVENTS.RESIZE, new ViewportEvent(@windowX, @windowY, getWidth(@window), getHeight(@window), event?.timeStamp))
  , 500)

module.exports = ViewportObserver
