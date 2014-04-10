EventStore = require_app("lib/redis_event_store")
_ = require('lodash')

class Event
  constructor: (windowId, action, timestamp, eventData) ->
    @attributes =
      action: action
      timestamp: timestamp
      data: eventData
      windowId: windowId

  @HUMAN_INTERACTION_ACTIONS: [
    "mouseClick",
    "mousePosition",
    "scroll",
    "selection"
  ]

  @eventsFromRequestJSON: (events) ->
    events = [events] unless _.isArray(events)
    events.map((eData) =>
      @fromJSON(eData)
    )

  @filterHumanInteraction: (events) ->
    events.filter( (event) => @HUMAN_INTERACTION_ACTIONS.indexOf(event.attributes.action) > -1 )

  toJSON: ->
    @attributes

  @fromJSON: ({action: action, timestamp: timestamp, data: data, windowId: windowId}) ->
    new Event(windowId, action, timestamp, data)

module.exports = Event
