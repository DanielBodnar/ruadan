_ = require('lodash')
Event = requireApp("app/models/event")
Session = requireApp("app/models/session")


module.exports = (app) ->

  class app.EventController


    # Record an event or a list of events
    @record = (req, res) ->
      Session.get(req.body.sessionId).then( (session) ->
        events = req.body.events
        Event.eventsFromRequestJSON(events).forEach((e) -> session.recordEvent(e))
      )

      res.json {}

    # view a list of events by sessionId
    @view = (req, res) ->
      sessionId = req.query.sessionId
      return res.json {} unless sessionId
      Session.get(sessionId).then( (session) ->
        session.getEvents().then( (events) ->
          res.json {
            events: events
          }
        )
      )
