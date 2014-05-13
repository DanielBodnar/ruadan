ObserverManager = require('./observers/observer_manager.coffee')

NodeMap = require('../node/node_map.coffee')

PageManager = require('./page_manager.coffee')
SessionManager = require('./session_manager.coffee')
WindowManager = require('./window_manager.coffee')
BookmarkEvent = require('../events/bookmark.coffee')

class Recorder
  constructor: (options) ->
    @nodeMap = new NodeMap()
    @window = options.window
    @rootElement = options.rootElement
    @client = new options.Client()
    @isRecording = false

    @sessionManager = new SessionManager(@client)
    @observersManager = new ObserverManager(@window, @rootElement, @nodeMap)

  # Tries to record to a given sessionId
  startRecordingWithSessionId: (pageName, sessionId, callback = ->) ->
    return if @isRecording

    start = ( (error) =>
      if (error?)
        console.error("Can't start recording", error)
        callback(error)
      else
        @isRecording = true
        @observersManager.start(@_recordEvents.bind(@))
        @newPage(pageName)
        callback(null, @sessionManager.getCurrentSession())
    )
    @sessionManager.useSessionId(sessionId, start)


  # Tries to record to an existing sessionId or starts a new session
  startRecording: (pageName, sessionName, forceNewSession = false, callback = ->) ->
    return null if @isRecording

    start = ( (error) =>
      if (error?)
        console.error("Can't start recording", error)
        callback(error)
      else
        @isRecording = true
        @observersManager.start(@_recordEvents.bind(@))
        @newPage(pageName)
        console.log("::started recording::")
        callback(null, @sessionManager.getCurrentSession())
    )

    if (forceNewSession)
      @sessionManager.startNewSession(sessionName, start)
    else
      @sessionManager.continueSession(sessionName, start)

  stopRecording: ->
    return null unless @isRecording
    @sessionManager.endSession( (error) =>
      console.error("Error when asking server to stop recording: " + error, "Stopping anyway") if error?
      @observersManager.stop()
      @isRecording = false
    )

  newPage: (pageName, takeSnapshot = true) ->
    throw new Exception("Can't capture new page before recording starts") unless (@isRecording)
    newPageEvent = PageManager.newPage(@window, pageName, @nodeMap, @rootElement, takeSnapshot)
    @_recordEvent(newPageEvent)

  bookmark: (text) ->
    throw new Exception("Can't bookmark before recording starts") unless (@isRecording)
    @_recordEvent(new BookmarkEvent(text))


  _recordEvents: (events) ->
    unless events instanceof Array
      events = [events]

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
