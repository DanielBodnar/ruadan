define([
#  'observer'
], (
#  Observer
)->
  class Recorder
    constructor: (options)->
      @client = options.client
      @rootElement = options.rootElement
#      @observer = new Observer()
      @_bindObserverEvents()

    initialize: ->
      @client.setViewportHeight(document.documentElement.clientHeight)
      @client.setViewportWidth(document.documentElement.clientWidth)
      @client.initialize(@rootElement)

    startRecording: ->
#      @observer.observe(@rootElement)

    stopRecording: ->
#      @observer.disconnect()

    _bindObserverEvents: ->
#      @observer.on('change', (mutations)=> @client.onChange(mutations))

)
