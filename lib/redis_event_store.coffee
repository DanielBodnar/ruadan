Redis = require('redis')
ShortId = require('shortid')
Promise = require('bluebird')
_ = require('lodash')

class EventStore

  _client = null

  REDIS_POSITIVE_INFINITY = '+inf'
  REDIS_NEGATIVE_INFINITY = '-inf'

  # The sesions are stored in redis as an unsorted set of session id strings,
  # indetified by the key 'sessions'

  # The events are stored in redis as a sorted set (the score would be the timestamp),
  # identified by the key 'session:<session_id>'

  _getClient = ->
    EventStore.client || _client = Promise.promisifyAll(Redis.createClient())

  _redisSessionId = (sessionId) ->
    "session:#{sessionId}"

  _sessionIdFromRedisSessionId = (redisSessionId) ->
    redisSessionId.split(':')[1]

  _getSessionForKey = (key) ->
    # This redis command gets the timestamp of the first event in the session
    _getClient().zrangebyscoreAsync(key, 0, REDIS_POSITIVE_INFINITY, 'withscores', 'limit', 0, 1)
      .then((keyAndScore) ->
        sessionId: _sessionIdFromRedisSessionId(key)
        timestamp: keyAndScore[1]
    )

  # return a promise which returns a new session id
  @startSession: ->
    newId = ShortId.generate()
    _getClient().saddAsync('sessions', newId).then(->
      newId
    )

  # returns a promise for a list of sessions matching to the given session keys
  # (basically, just get the timestamp for each session)
  @getSessionsForIds: (ids) ->
    promises = []

    ids.forEach((id) ->
      promises.push(_getSessionForKey(_redisSessionId(id)))
    )

    Promise.all(promises)

  @getSessionForId: (id) ->
    _getSessionForKey(_redisSessionId(id))

  # returns a promise for a list of sessions
  @getSessions: ->
    _getClient().smembersAsync("sessions").then( (keys) ->
      EventStore.getSessionsForIds(keys)
    )

  # record an event for session, return a completion promise
  @recordEvent: (sessionId, timestamp, event) ->
    return Promise.reject("No timestamp for event") unless event.attributes.timestamp
    _getClient().zaddAsync(_redisSessionId(sessionId),
                                     timestamp, JSON.stringify(event))

  @getEvents: (sessionId) ->
    _getClient().zrangebyscoreAsync(_redisSessionId(sessionId), 0, REDIS_POSITIVE_INFINITY)

  _getDOMInitKey = (sessionId) ->
    "#{_redisSessionId(sessionId)}:domInited"

  @isDOMInitialized: (sessionId) ->
    _getClient().getAsync(_getDOMInitKey(sessionId)).then( (result) ->
      result == 'true'
    )

  @markDOMInitialized: (sessionId) ->
    _getClient().setAsync(_getDOMInitKey(sessionId), true)

module.exports = EventStore
