class SessionManager
  @sessionIdKey: "ruadanSessionId"

  constructor: (@client) ->

  getCurrentSession: ->
    @_getSessionId()

  continueSession: (name, callback) ->
    currentSessionId = @_getSessionId()
    if (currentSessionId)
      @_continueCurrentSession(currentSessionId, (error, canContinue) =>
        if (canContinue)
          console.log('continuing session ' + currentSessionId) unless error?
          callback(error, currentSessionId) if callback
        else
          @startNewSession(name, callback)
      )
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
      console.log('ending session ' + @_getSessionId()) unless error?
      @_setSessionId(null) unless error?
      callback(error) if callback
    )

  _continueCurrentSession: (sessionId, callback) ->
    @client.continueSession(sessionId, (error, result) =>
      callback(error, result?.canContinue)
    )

  _startSession: (name, callback) ->
    @client.newSession(name, (error, sessionId) =>
      @_setSessionId(sessionId) unless error?
      console.log('starting session ' + sessionId) unless error?
      callback(error, sessionId) if callback
    )

  _setSessionId: (sessionId) ->
    if (sessionId?)
      localStorage.setItem(SessionManager.sessionIdKey, sessionId)
    else
      localStorage.removeItem(SessionManager.sessionIdKey)

  _getSessionId: ->
    localStorage.getItem(SessionManager.sessionIdKey)

module.exports = SessionManager
