EventStore = require_app("lib/redis_event_store")
Event = require_app("app/models/event")
Promise = require('bluebird')

class Session

  _recordEventInternal = (session, event) ->


  constructor: (id, timestamp) ->
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

  @allValid: ->
    # first, get all sessions,
    Session.all().then( (sessions) ->

      # then, create promises which check each session for validity
      promises = sessions.map((session) ->
        session.isValid()
      )

      # then, wait for the validation checks to finish, and then,
      Promise.all(promises).then((results) ->

        # filter out the invalid sessions!
        session for session, i in sessions when results[i]
      )

    )

  @start: ->
    EventStore.startSession().then((newId) ->
      new Session(newId)
    )

  getTimestamp: ->
    @attributes.timestamp = EventStore.getSessionForId(@attributes.id)

  isValid: ->
    EventStore.isDOMInitialized(@attributes.id)

  recordEvent: (event) ->
    EventStore.recordEvent(@attributes.id, event.attributes.timestamp, event).then( =>
      if event.attributes.action == 'initialMutationState'
        EventStore.markDOMInitialized(@attributes.id)
    )

  getEvents: ->
    EventStore.getEvents(@attributes.id).then((results) ->
      results.map((json) ->
        Event.fromJSON(JSON.parse(json))
      )
    )

  toJSON: ->
    @attributes


module.exports = Session
