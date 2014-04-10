EventStore = require_app("lib/redis_event_store")
Event = require_app("app/models/event")
Promise = require("bluebird")

class Session
  SESSION_INACTIVITY_TIMEOUT: 300000 # ms (5 mins)

  constructor: (id, name, startTimestamp, endTimestamp) ->
    @attributes = {
      id: id
      name: name
      startTimestamp: startTimestamp
      endTimestamp: endTimestamp
    }

  @all: ->
    EventStore.getSessions().then((sessions) =>
      sessions.sort( (a, b) -> b.startTimestamp - a.startTimestamp ).map((session) =>
        @fromSessionData(session)
      )
    )

  @get: (sessionId) ->
    EventStore.getSession(sessionId).then( (session) =>
      @fromSessionData(session)
    )

  @start: (name, timestamp = new Date().getTime()) ->
    EventStore.startSession(name, timestamp).then((newId) ->
      new Session(newId, name, timestamp)
    )

  @end: (sessionId, timestamp = new Date().getTime()) ->
    @get(sessionId).then( (session) -> session.end(timestamp) )

  @fromSessionData: (sessionData) ->
    new Session(sessionData.id, sessionData.name, sessionData.startTimestamp, sessionData.endTimestamp)

  delete: ->
    promise = EventStore.deleteSession(@attributes.id)
    promise.then( => @attributes.id = null )
    promise

  end: (timestamp = new Date().getTime()) ->
    return Promise.resolve() if @isEnded()
    EventStore.endSession(@attributes.id, timestamp)

  isEnded: ->
    @attributes.endTimestamp?

  lastActivityTime: ->
    events = Event.filterHumanInteraction(@getEvents())
    lastEvent = if (events.length > 0) then events[events.length-1] else null
    if (lastEvent) then lastEvent.attributes.timestamp else @attributes.startTimestamp

  isInactive: ->
    return false if @isEnded()
    lastActivity = @lastActivityTime()
    now = new Date().getTime()
    timeSinceLastActivity = now - lastActivity
    timeSinceLastActivity > @SESSION_INACTIVITY_TIMEOUT

  canContinue: ->
    !@isEnded()

  recordEvent: (event) ->
    Promise.reject("Can't add events to an ended session") if @attributes.endTimestamp*1
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
