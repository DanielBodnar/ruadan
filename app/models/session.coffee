EventStore = require_app("lib/redis_event_store")
Event = require_app("app/models/event")

class Session
  constructor: (id = EventStore.startSession(), timestamp) ->
    @attributes = {
      id: id
      timestamp: timestamp
    }

  @all: ->
    EventStore.getSessions().then((data) ->
      data.map((sessionData) ->
        new Session(sessionData.sessionId, sessionData.timestamp)
      )
    )

  getTimestamp: ->
    @attributes.timestamp = EventStore.getSessionForId(@attributes.id)

  recordEvent: (event) ->
    EventStore.recordEvent(@attributes.id, event.attributes.timestamp, event)

  getEvents: ->
    EventStore.getEvents(@attributes.id).then((results) ->
      results.map((json) ->
        Event.fromJSON(JSON.parse(json))
      )
    )

  toJSON: ->
    @attributes


module.exports = Session
