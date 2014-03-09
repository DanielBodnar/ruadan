Redis = require('redis')
ShortId = require('shortid')
Promise = require('bluebird')
_ = require('lodash')

class EventStore

  REDIS_POSITIVE_INFINITY = '+inf'
  REDIS_NEGATIVE_INFINITY = '-inf'

  # return a promise which returns a new session id
  @startSession: ->
    newId = ShortId.generate()
    saddAsync = _promisifyRedisCommand('sadd')
    saddAsync('sessions', newId).then(->
      newId
    )

  # returns a promise for a list of sessions
  @getSessions: ->
    smembersAsync = _promisifyRedisCommand('smembers')
    smembersAsync("sessions").then( (keys) ->
      EventStore.getSessionsForIds(keys)
    )

  # returns a promise for a list of sessions matching to the given session keys
  # (basically, just get the timestamp for each session)
  @getSessionsForIds: (sessionIds) ->
    promises = []

    sessionIds.forEach((sessionId) ->
      promises.push(_getSessionForKey(_redisSessionId(sessionId)))
    )

    Promise.all(promises)

  @getSessionForId: (sessionId) ->
    _getSessionForKey(_redisSessionId(sessionId))

  # record an event for session, return a completion promise
  @recordEvent: (sessionId, timestamp, event) ->
    return Promise.reject("No timestamp for event") unless event.attributes.timestamp
    zaddAsync = _promisifyRedisCommand('zadd')
    zaddAsync(_redisSessionId(sessionId), timestamp, JSON.stringify(event))

  @getEvents: (sessionId) ->
    zrangebyscoreAsync = _promisifyRedisCommand('zrangebyscore')
    zrangebyscoreAsync(_redisSessionId(sessionId), 0, REDIS_POSITIVE_INFINITY)

  @isDOMInitialized: (sessionId) ->
    getAsync = _promisifyRedisCommand('get')
    getAsync(_getDOMInitKey(sessionId)).then( (result) ->
      result == 'true'
    )

  @markDOMInitialized: (sessionId) ->
    setAsync = _promisifyRedisCommand('set')
    setAsync(_getDOMInitKey(sessionId), true)



  #### PRIVATES #####################################################################

  _client = null

  # The sesions are stored in redis as an unsorted set of session id strings,
  # indetified by the key 'sessions'

  # The events are stored in redis as a sorted set (the score would be the timestamp),
  # identified by the key 'session:<session_id>'

  _getClient = ->
    _client || _client = Redis.createClient()

  _promisifyMethod = (obj, method) ->
    Promise.promisify(obj[method], obj)

  _promisifyRedisCommand = (command) ->
    _promisifyMethod(_getClient(), command)

  _redisSessionId = (sessionId) ->
    "session:#{sessionId}"

  _sessionIdFromRedisSessionId = (redisSessionId) ->
    redisSessionId.split(':')[1]

  _getSessionForKey = (key) ->
    # This redis command gets the timestamp of the first event in the session
    zrangebyscoreAsync = _promisifyRedisCommand('zrangebyscore')
    zrangebyscoreAsync(key, 0, REDIS_POSITIVE_INFINITY, 'withscores', 'limit', 0, 1)
      .then((keyAndScore) ->
        sessionId: _sessionIdFromRedisSessionId(key)
        timestamp: keyAndScore[1]
    )

  _getDOMInitKey = (sessionId) ->
    "#{_redisSessionId(sessionId)}:domInited"


module.exports = EventStore
