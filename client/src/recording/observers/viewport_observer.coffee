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
    @_debouncedOnChange = _.debounce(@_onChange, 100)
    @window.addEventListener('resize', @_debouncedOnChange, true)
#WHY DO WE NEED THIS?
    @interval = setInterval( ( =>
      newX = @window.screenLeft - @window.screen.availLeft
      newY = @window.screenTop - @window.screen.availTop
      if (@windowX != newX || @windowY != newY)
        @windowX = newX
        @windowY = newY
        @_debouncedOnChange()
    ), 100)

  disconnect: ->
    @window.removeEventListener('resize', @_debouncedOnChange, true)
#    clearInterval(@interval)

  _onChange: (event) =>
    resizeEvent = new ViewportEvent(@windowX, @windowY, getWidth(@window), getHeight(@window), event?.timeStamp)
    @emit(@constructor.EVENTS.RESIZE, resizeEvent)

module.exports = ViewportObserver
