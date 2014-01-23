define([
  'recording/observers/mutation_observer'
  'recording/observers/mouse_observer'
  'recording/observers/scroll_observer'
  'recording/observers/viewport_observer'
], (
  MutationObserver
  MouseObserver
  ScrollObserver
  ViewportObserver
)->
  class Recorder
    constructor: (options)->
      @client = options.client
      @rootElement = options.rootElement
      @mutationObserver = new MutationObserver()
      @mouseObserver = new MouseObserver()
      @scrollingObserver = new ScrollObserver()
      @viewportObserver = new ViewportObserver()
      @_bindObserverEvents()

    initialize: ->
      @scrollingObserver.initialize(window)
      @mutationObserver.initialize(@rootElement)
      @mouseObserver.initialize(@rootElement)
      @viewportObserver.initialize(@rootElement)
      @client.initialize(@rootElement)

    startRecording: ->
      @mutationObserver.observe(@rootElement)
      @scrollingObserver.observe(@rootElement)
      @mouseObserver.observe(@rootElement)

    stopRecording: ->
      @mutationObserver.disconnect()
      @scrollingObserver.disconnect()
      @mouseObserver.disconnect()

    _bindObserverEvents: ->
#      @mutationObserver.on('change', (mutations)=> @client.onChange(mutations))
      @scrollingObserver.on('initialize', (info) => @client.setInitialScrollState(info))
      @scrollingObserver.on('scroll', (info) => @client.onScroll(info))
      @mutationObserver.on('initialize', (info) => @client.setInitialMutationState(info))
      @viewportObserver.on('initialize', (info) => @client.setInitialViewportState(info))
#      @mouseObserver.on('mouseMoved', (position)=> @client.onMouseMove(position))

)
