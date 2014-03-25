EventEmitter = require('eventemitter').EventEmitter
_ = require('lodash.custom')
ViewportEvent = require('../../events/viewport.coffee')

getWidth= (win) ->
  win.document.documentElement.clientWidth

getHeight= (win) ->
  win.document.documentElement.clientHeight

class ViewportObserver extends EventEmitter
  constructor: (@window) ->
    @_debouncedOnChange = _.debounce(@_onChange, 500)

  observe: ->
    @window.addEventListener('resize', @_debouncedOnChange, true)

  disconnect: ->
    @window.removeEventListener('resize', @_debouncedOnChange, true)

  _onChange: (event) =>
    @emit('resize', new ViewportEvent(getWidth(@window), getHeight(@window), event.timeStamp))

module.exports = ViewportObserver
