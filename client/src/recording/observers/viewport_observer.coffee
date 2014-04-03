EventEmitter = require('eventemitter').EventEmitter
_ = require('lodash.custom')
ViewportEvent = require('../../events/viewport.coffee')

getWidth= (win) ->
  win.innerWidth

getHeight= (win) ->
  win.innerHeight

class ViewportObserver extends EventEmitter
  constructor: (@window) ->
    @_debouncedOnChange = _.debounce(@_onChange, 500)
    @windowX = @windowY = 0

  observe: ->
    @window.addEventListener('resize', @_debouncedOnChange, true)
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
    clearInterval(@interval)

  _onChange: (event) =>
    @emit('resize', new ViewportEvent(@windowX, @windowY, getWidth(@window), getHeight(@window), event?.timeStamp))

module.exports = ViewportObserver
