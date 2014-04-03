Redis = require('redis')
ShortId = require('shortid')
Promise = require('bluebird')

class EventStore
  REDIS_POSITIVE_INFINITY = '+inf'
  REDIS_NEGATIVE_INFINITY = '-inf'

  # return a promise which returns a new session id
  @startSession: (name, timestamp) ->
    newId = ShortId.generate()
    saddAsync = _promisifyRedisCommand('sadd')
    hmsetAsync = _promisifyRedisCommand('hmset')
    saddAsync('sessions', newId).then( ->
      hmsetAsync(_redisSessionId(newId), {
        id: newId,
        name: name,
        startTimestamp: timestamp,
      })
    ).then( ->
      newId
    )

  @endSession: (sessionId, timestamp) ->
    hsetAsync = _promisifyRedisCommand('hset')
    hsetAsync(_redisSessionId(sessionId), "endTimestamp", timestamp)

  @getSession: (sessionId) ->
    hgetallAsync = _promisifyRedisCommand('hgetall')
    hgetallAsync(_redisSessionId(sessionId))

  # returns a promise for a list of sessions
  @getSessions: ->
    smembersAsync = _promisifyRedisCommand('smembers')
    smembersAsync("sessions").then( (keys) =>
      @_getSessionsForIds(keys)
    )

  # record an event for session, return a completion promise
  @recordEvent: (sessionId, timestamp, event) ->
    return Promise.reject("No timestamp for event") unless event?.attributes?.timestamp
    zaddAsync = _promisifyRedisCommand('zadd')
    zaddAsync(_redisSessionEventsId(sessionId), timestamp, JSON.stringify(event))

  @getEvents: (sessionId) ->
    zrangebyscoreAsync = _promisifyRedisCommand('zrangebyscore')
    zrangebyscoreAsync(_redisSessionEventsId(sessionId), 0, REDIS_POSITIVE_INFINITY)

  # returns a promise for a list of sessions matching to the given session keys
  # (basically, just get the timestamp for each session)
  @_getSessionsForIds: (sessionIds) ->
    promises = []

    sessionIds.forEach((sessionId) =>
      promises.push(@getSession(sessionId))
    )

    Promise.all(promises)


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

  _redisSessionEventsId = (sessionId) ->
    "session:#{sessionId}:events"

  _redisSessionId = (sessionId) ->
    "session:#{sessionId}"

module.exports = EventStore
