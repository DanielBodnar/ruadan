_ = require('lodash')
Event = require_app("app/models/event")
Session = require_app("app/models/session")


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
