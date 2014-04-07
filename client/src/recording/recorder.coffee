MutationObserver = require('./observers/mutation_observer.coffee')
MouseObserver = require('./observers/mouse_observer.coffee')
ScrollObserver = require('./observers/scroll_observer.coffee')
ViewportObserver = require('./observers/viewport_observer.coffee')
TextSelectionObserver = require('./observers/text_selection_observer.coffee')
UrlObserver = require('./observers/url_observer.coffee')
VisibilityObserver = require('./observers/visibility_observer.coffee')
FocusObserver = require('./observers/focus_observer.coffee')
WindowCloseObserver = require('./observers/window_close_observer.coffee')

NodeMap = require('../node/node_map.coffee')

PageManager = require('./page_manager.coffee')
SessionManager = require('./session_manager.coffee')
WindowManager = require('./window_manager.coffee')
BookmarkEvent = require('../events/bookmark.coffee')

class Recorder
  constructor: (options) ->
    @nodeMap = new NodeMap()
    @window = options.document.defaultView
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
      visibility: new VisibilityObserver(@document)
      focus: new FocusObserver(@window)
      windowClose: new WindowCloseObserver(@window)
    }

  # Tries to record to a given sessionId
  startRecordingWithSessionId: (pageName, sessionId, callback = ->) ->
    unless (@isRecording)
      start = ( (error) =>
        if (error?)
          console.error("Can't start recording", error)
          callback(error)
        else
          @isRecording = true
          @_startObservers()
          @newPage(pageName)
          callback(null, @sessionManager.getCurrentSession())
      )
      @sessionManager.useSessionId(sessionId, start)


  # Tries to record to an existing sessionId or starts a new session
  startRecording: (pageName, sessionName, forceNewSession = false, callback = ->) ->
    unless (@isRecording)
      start = ( (error) =>
        if (error?)
          console.error("Can't start recording", error)
          callback(error)
        else
          @isRecording = true
          @_startObservers()
          @newPage(pageName)
          callback(null, @sessionManager.getCurrentSession())
      )

      if (forceNewSession)
        @sessionManager.startNewSession(sessionName, start)
      else
        @sessionManager.continueSession(sessionName, start)

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
    for key, v of @observers
      v.disconnect()

  _bindObserverEvents: (observers) ->
    observers.url.on('urlChanged', (event) => @_recordEvent(event))
    observers.scrolling.on('scroll', (event) => @_recordEvent(event))
    observers.mutation.on('change', (event) => @_recordEvents(event))
    observers.viewport.on('resize', (event) => @_recordEvent(event))
    observers.selection.on('select', (event) => @_recordEvent(event))
    observers.mouse.on('mouse_clicked', (event) => @_recordEvent(event))
    observers.mouse.on('mouse_moved', (event) => @_recordEvent(event))
    observers.visibility.on('visibility_changed', (event) => @_recordEvent(event))
    observers.focus.on('focus_changed', (event) => @_recordEvent(event))
    observers.windowClose.on('window_closed', (event) => @_recordEvent(event))

  _unbindObserverEvents: (observers) ->
    observers.url.removeAllListeners('urlChanged')
    observers.scrolling.removeAllListeners('scroll')
    observers.mutation.removeAllListeners('change')
    observers.viewport.removeAllListeners('resize')
    observers.selection.removeAllListeners('select')
    observers.mouse.removeAllListeners('mouse_clicked')
    observers.mouse.removeAllListeners('mouse_moved')
    observers.visibility.removeAllListeners('visibility_changed')
    observers.focus.removeAllListeners('focus_changed')
    observers.windowClose.removeAllListeners('window_closed')

  _recordEvents: (events) ->
    events.forEach( (event) =>
      @_recordEvent(event)
    )

  _recordEvent: (event) ->
    event.setWindowId(WindowManager.getWindowId())
    @client.recordEvent(@sessionManager.getCurrentSession(), event, (error) ->
      if (error?)
        console.error("Recording failed: " + error, event.toJson())
      else
        console.log("Recorded", event.toJson())
    )

module.exports = Recorder
