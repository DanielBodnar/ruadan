define([
  'recording/observers/mutation_observer'
  'recording/observers/mouse_observer'
], (
  MutationObserver
  MouseObserver
)->
  class Recorder
    constructor: (options)->
      @client = options.client
      @rootElement = options.rootElement
      @mutationObserver = new MutationObserver()
      @mouseObserver = new MouseObserver()
      @_bindObserverEvents()

    initialize: ->
      @client.setViewportHeight(document.documentElement.clientHeight)
      @client.setViewportWidth(document.documentElement.clientWidth)
      @client.initialize(@rootElement)

    startRecording: ->
      @mutationObserver.observe(@rootElement)
      @mouseObserver.observe(@rootElement)

    stopRecording: ->
      @mutationObserver.disconnect()
      @mouseObserver.disconnect()

    _bindObserverEvents: ->
      @mutationObserver.on('change', (mutations)=> @client.onChange(mutations))
      @mouseObserver.on('change', (data)=>
        console.log("mouse moved", data.x, data.y)
      )

)
