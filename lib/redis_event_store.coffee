Redis = require('redis')
ShortId = require('shortid')
Promise = require('bluebird')
_ = require('lodash')

class EventStore

  @client: null

  REDIS_POSITIVE_INFINITY = '+inf'
  REDIS_NEGATIVE_INFINITY = '-inf'

  @getClient: ->
    EventStore.client || EventStore.client = Promise.promisifyAll(Redis.createClient())

  @redisSessionId: (sessionId) ->
    "session:#{sessionId}"

  @sessionIdFromRedisSessionId: (redisSessionId) ->
    redisSessionId.split(':')[1]

  # return new session id
  @startSession: ->
    ShortId.generate()

  @getSessionForId: (id) ->
    EventStore.getSessionForKey(EventStore.redisSessionId(id))

  @getSessionForKey: (key) ->
    # This redis command gets the timestamp of the first event in the session
    EventStore.getClient().zrangebyscoreAsync(key, 0, REDIS_POSITIVE_INFINITY, 'withscores', 'limit', 0, 1)
      .then((keyAndScore) ->
        sessionId: EventStore.sessionIdFromRedisSessionId(key)
        timestamp: keyAndScore[1]
    )

  # returns a promise for a list of sessions matching to the given session keys
  # (basically, just get the timestamp for each session)
  @getSessionsForKeys: (keys) ->
    promises = []

    keys.forEach((key) ->
      promises.push(EventStore.getSessionForKey(key))
    )

    Promise.all(promises)

  # returns a promise for a list of sessions
  @getSessions: ->
    EventStore.getClient().keysAsync("session:*").then( (keys) ->
      EventStore.getSessionsForKeys(keys)
    )

  # record an event for session, return a completion promise
  @recordEvent: (sessionId, timestamp, event) ->
    return Promise.reject("No timestamp for event") unless event.attributes.timestamp
    EventStore.getClient().zaddAsync(EventStore.redisSessionId(sessionId),
                                     timestamp, JSON.stringify(event))

  @getEvents: (sessionId) ->
    EventStore.getClient().zrangebyscoreAsync(EventStore.redisSessionId(sessionId), 0, REDIS_POSITIVE_INFINITY)


module.exports = EventStore
