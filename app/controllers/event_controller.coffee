_ = require('lodash')
Event = require_app("app/models/event")
Session = require_app("app/models/session")


module.exports = (app) ->

  class app.EventController


    # Record an event or a list of events
    @record = (req, res) ->
      s = new Session(req.body.sessionId)
      action = req.body.action
      data = req.body.data
      Event.eventsFromRequestJSON(action, data).forEach((e) -> s.recordEvent(e))

      res.json {}

    # view a list of events by sessionId
    @view = (req, res) ->
      sessionId = req.query.sessionId
      return res.json {} unless sessionId
      new Session(sessionId).getEvents().done( (events) ->
        res.json {
          events: events
        }
      )
