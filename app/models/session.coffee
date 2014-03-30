EventStore = require_app("lib/redis_event_store")
Event = require_app("app/models/event")

class Session
  constructor: (id, name, startTimestamp, endTimestamp) ->
    @attributes = {
      id: id
      name: name
      startTimestamp: startTimestamp
      endTimestamp: endTimestamp
    }

  @all: ->
    EventStore.getSessions().then((sessions) ->
      sessions.sort( (a, b) -> b.startTimestamp - a.startTimestamp ).map((session) ->
        new Session(session.id, session.name, session.startTimestamp, session.endTimestamp)
      )
    )

  @get: (sessionId) ->
    EventStore.getSession(sessionId).then( (session) ->
      new Session(session.id, session.name, session.startTimestamp, session.endTimestamp)
    )

  @start: (name, timestamp = new Date().getTime()) ->
    EventStore.startSession(name, timestamp).then((newId) ->
      new Session(newId, name, timestamp)
    )

  @end: (sessionId, timestamp = new Date().getTime()) ->
    EventStore.endSession(sessionId, timestamp)

  canContinue: ->
    !@attributes.endTimestamp

  recordEvent: (event) ->
    throw new Error("Can't add events to an ended session") if @attributes.endTimestamp*1
    EventStore.recordEvent(@attributes.id, event.attributes.timestamp, event)

  getEvents: ->
    EventStore.getEvents(@attributes.id).then((events) ->
      events.map((eventJson) ->
        Event.fromJSON(JSON.parse(eventJson))
      )
    )

  toJSON: ->
    @attributes


module.exports = Session
