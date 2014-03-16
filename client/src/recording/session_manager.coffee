class SessionManager
  @sessionIdKey: "ruadanSessionId"

  constructor: (@client) ->

  getCurrentSession: ->
    @_getSessionId()

  continueSession: (name, callback) ->
    currentSessionId = @_getSessionId()
    if (currentSessionId)
      # TODO: ask the server before resuming a session - it may have expired
      callback(null, currentSessionId) if callback
    else
      @startNewSession(name, callback)

  startNewSession: (name, callback) ->
    if (@_getSessionId())
      # only allow one session at a time.
      @endSession((error) =>
        if (error?)
          callback(error) if callback
        else
          @_startSession(name, callback)
      )
    else
      @_startSession(name, callback)

  endSession: (callback) ->
    @client.endSession(@_getSessionId(), (error) =>
      @_setSessionId(null) unless error?
      callback(error) if callback
    )

  _startSession: (name, callback) ->
    @client.newSession(name, (error, sessionId) =>
      @_setSessionId(sessionId) unless error?
      callback(error, sessionId) if callback
    )

  _setSessionId: (sessionId) ->
    localStorage.setItem(SessionManager.sessionIdKey, sessionId)

  _getSessionId: ->
    localStorage.getItem(SessionManager.sessionIdKey)

module.exports = SessionManager
