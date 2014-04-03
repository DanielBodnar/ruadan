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
      if (@windowX != @window.screenLeft || @windowY != @window.screenTop)
        @windowX = @window.screenLeft - @window.screen.availLeft
        @windowY = @window.screenTop - @window.screen.availTop
        @_debouncedOnChange()
    ), 100)

  disconnect: ->
    @window.removeEventListener('resize', @_debouncedOnChange, true)
    clearInterval(@interval)

  _onChange: (event) =>
    @emit('resize', new ViewportEvent(@windowX, @windowY, getWidth(@window), getHeight(@window), event?.timeStamp))

module.exports = ViewportObserver
