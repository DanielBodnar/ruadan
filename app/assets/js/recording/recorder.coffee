define([
  'lodash'
  'recording/observers/mutation_observer'
  'recording/observers/mouse_observer'
  'recording/observers/scroll_observer'
  'recording/observers/viewport_observer'
], (
  _
  MutationObserver
  MouseObserver
  ScrollObserver
  ViewportObserver
)->
  class Recorder
    constructor: (options)->
      @rootElement = options.rootElement
      @client = new options.Client(options.document, @rootElement)

      @observers = {
        mutation: new MutationObserver()
        mouse: new MouseObserver()
        scrolling: new ScrollObserver()
        viewport: new ViewportObserver()
      }

      @_bindObserverEvents(@observers)

      @initialize()

    initialize: ->
      @observers.scrolling.initialize(window)
      @observers.mutation.initialize(@rootElement)
      @observers.mouse.initialize(@rootElement)
      @observers.viewport.initialize(@rootElement)

    startRecording: ->
      _.each(@observers, (v, k)-> v.observe())

    stopRecording: ->
      _.each(@observers, (v, k)-> v.disconnect())

    _bindObserverEvents: (observers)->
#      @mutationObserver.on('change', (mutations)=> @client.onChange(mutations))
      observers.scrolling.on('initialize', (info) => @client.setInitialScrollState(info))
      observers.scrolling.on('scroll', (info) => @client.onScroll(info))
      observers.mutation.on('initialize', (info) => @client.setInitialMutationState(info))
      observers.viewport.on('initialize', (info) => @client.setInitialViewportState(info))
#      @mouseObserver.on('mouseMoved', (position)=> @client.onMouseMove(position))

)
