define([
  'lodash'
  'recording/observers/mutation_observer'
  'recording/observers/mouse_observer'
  'recording/observers/scroll_observer'
  'recording/observers/viewport_observer'
  'recording/observers/text_selection_observer'
], (
  _
  MutationObserver
  MouseObserver
  ScrollObserver
  ViewportObserver
  TextSelectionObserver
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
        selection: new TextSelectionObserver()
      }

      @_bindObserverEvents(@observers)

      @initialize()

    initialize: ->
      @observers.scrolling.initialize(window)
      @observers.mutation.initialize(@rootElement)
      @observers.mouse.initialize(window)
      @observers.viewport.initialize(@rootElement)
      @observers.selection.initialize(document) #seems to only be available on the document :-/

    startRecording: ->
      _.each(@observers, (v, _)-> v.observe())

    stopRecording: ->
      _.each(@observers, (v, _)-> v.disconnect())


    _processSelectionObject: (data, fn)->
      data.anchorNode = @observers.mutation.serializer.knownNodesMap.get(data.anchorNode) if data.anchorNode
      data.focusNode = @observers.mutation.serializer.knownNodesMap.get(data.focusNode) if data.focusNode
      fn(data)

    _bindObserverEvents: (observers)->
      observers.scrolling.on('initialize', (info) => @client.setInitialScrollState(info))
      observers.scrolling.on('scroll', (info) => @client.onScroll(info))

      observers.mutation.on('initialize', @client.setInitialMutationState.bind(@client))
      observers.mutation.on('change', @client.onMutation.bind(@client))

      observers.viewport.on('initialize', (info) => @client.setInitialViewportState(info))

      observers.selection.on('initialize', (data)=> @_processSelectionObject(data, @client.setInitialSelection.bind(@client)))
      observers.selection.on('select', (data)=> @_processSelectionObject(data, @client.onSelect.bind(@client)))

      observers.mouse.on('mouse_moved', (position)=> @client.onMouseMove(position))

)
