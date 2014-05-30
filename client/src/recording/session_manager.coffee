class SessionManager
  @sessionIdKey: "ruadanSessionId"

  constructor: (@client) ->

  getCurrentSession: ->
    @_getSessionId()

  continueSession: (name, callback = ->) ->
    currentSessionId = @_getSessionId()
    if (currentSessionId)
      @_continueCurrentSession(currentSessionId, (error, canContinue) =>
        return callback(error) if error
        if (canContinue)
          console.info('continuing session ' + currentSessionId)
          callback(error, currentSessionId)
        else
          @startNewSession(name, callback)
      )
    else
      @startNewSession(name, callback)

  startNewSession: (name, callback = ->) ->
    if (@_getSessionId())
      # only allow one session at a time.
      @endSession((error) =>
        if (error?)
          callback(error)
        else
          @_startSession(name, callback)
      )
    else
      @_startSession(name, callback)

  useSessionId: (sessionId, callback = ->) ->
    @_continueCurrentSession(sessionId, (error, canContinue) =>
      return callback(error) if error
      if (canContinue)
        @_setSessionId(sessionId)
        callback(null)
      else
        callback("Can't continue session: " + sessionId)
    )

  endSession: (callback = ->) ->
    @client.endSession(@_getSessionId(), (error) =>
      console.info('ending session ' + @_getSessionId()) unless error?
      @_setSessionId(null) unless error?
      callback(error)
    )

  _continueCurrentSession: (sessionId, callback = ->) ->
    @client.continueSession(sessionId, (error, result) =>
      callback(error, result?.canContinue)
    )

  _startSession: (name, callback = ->) ->
    @client.newSession(name, (error, sessionId) =>
      return callback(error) if error
      @_setSessionId(sessionId)
      console.info('starting session ' + sessionId)
      callback(error, sessionId)
    )

  _setSessionId: (sessionId) ->
    if (sessionId?)
      sessionStorage.setItem(SessionManager.sessionIdKey, sessionId)
    else
      sessionStorage.removeItem(SessionManager.sessionIdKey)

  _getSessionId: ->
    sessionStorage.getItem(SessionManager.sessionIdKey)

module.exports = SessionManager
