MutationObserver = require('./observers/mutation_observer.coffee')
MouseObserver = require('./observers/mouse_observer.coffee')
ScrollObserver = require('./observers/scroll_observer.coffee')
ViewportObserver = require('./observers/viewport_observer.coffee')
TextSelectionObserver = require('./observers/text_selection_observer.coffee')
UrlObserver = require('./observers/url_observer.coffee')

NodeMap = require('./node_map.coffee')

PageManager = require('./page_manager.coffee')
SessionManager = require('./session_manager.coffee')
BookmarkEvent = require('./events/bookmark.coffee')

class Recorder
  constructor: (options) ->
    @nodeMap = new NodeMap()
    @window = options.window
    @document = options.document
    @rootElement = options.rootElement
    @client = new options.Client()
    @isRecording = false
    @sessionManager = new SessionManager(@client)

    @observers = {
      mutation: new MutationObserver(@rootElement, @nodeMap)
      mouse: new MouseObserver(@window)
      scrolling: new ScrollObserver(@window)
      viewport: new ViewportObserver(@window)
      url: new UrlObserver(@window)
      selection: new TextSelectionObserver(@document, @nodeMap)
    }

  startRecording: (pageName, sessionName, forceNewSession = false) ->
    unless (@isRecording)
      callback = ( (error) =>
        if (error?)
          console.error("Can't start recording: " + error)
        else
          @isRecording = true
          @_startObservers()
          @newPage(pageName)
      )

      if (forceNewSession)
        @sessionManager.startNewSession(sessionName, callback)
      else
        @sessionManager.continueSession(sessionName, callback)

  stopRecording: ->
    if (@isRecording)
      @sessionManager.endSession( (error) =>
        console.error("Error when asking server to stop recording: " + error, "Stopping anyway") if error?
        @_stopObservers()
        @isRecording = false
      )

  newPage: (pageName, takeSnapshot = true) ->
    throw new Exception("Can't capture new page before recording starts") unless (@isRecording)
    newPageEvent = PageManager.newPage(@window, pageName, @nodeMap, @rootElement, takeSnapshot)
    @_recordEvent(newPageEvent)

  bookmark: (text) ->
    throw new Exception("Can't bookmark before recording starts") unless (@isRecording)
    @_recordEvent(new BookmarkEvent(text))

  _startObservers: ->
    @_bindObserverEvents(@observers)
    for key, v of @observers
      v.observe()

  _stopObservers: ->
    @_unbindObserverEvents(@observers)
    for key, v of observers
      v.disconnect()

  _bindObserverEvents: (observers) ->
    observers.url.on('urlChanged', (event) => @_recordEvent(event))
    observers.scrolling.on('scroll', (event) => @_recordEvent(event))
    observers.mutation.on('change', (event) => @_recordEvents(event))
    observers.viewport.on('resize', (event) => @_recordEvent(event))
    observers.selection.on('select', (event) => @_recordEvent(event))
    observers.mouse.on('mouse_clicked', (event) => @_recordEvent(event))
    observers.mouse.on('mouse_moved', (event) => @_recordEvent(event))

  _unbindObserverEvents: (observers) ->
    observers.url.off('urlChanged')
    observers.scrolling.off('scroll')
    observers.mutation.off('change')
    observers.viewport.off('resize')
    observers.selection.off('select')
    observers.mouse.off('mouse_clicked')
    observers.mouse.off('mouse_moved')

  _recordEvents: (events) ->
    events.forEach( (event) =>
      @_recordEvent(event)
    )

  _recordEvent: (event) ->
    @client.recordEvent(@sessionManager.getCurrentSession(), event, (error) ->
      if (error?)
        console.error("Recording failed: " + error, event.toJson())
      else
        console.log("Recorded", event.toJson())
    )

module.exports = Recorder
