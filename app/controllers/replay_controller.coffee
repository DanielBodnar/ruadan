Session = require_app("app/models/session")

module.exports = (app) ->

  class app.ReplayController
    @replay = (req, res) ->
      res.render 'replay', sessionId: req.params.sessionId

    @sessions = (req, res) ->
      Session.all().then((sessions) ->
        pad = (number) ->
          if (number < 10)
            "0" + number
          else
            number

        printTime = (timestamp) ->
          return "N/A" unless timestamp*1
          date = new Date(timestamp*1)
          [
            [
              pad(date.getDate()),
              pad(date.getMonth()),
              date.getFullYear()
            ].join("/"),
            [
              pad(date.getHours()),
              pad(date.getMinutes()),
              pad(date.getSeconds())
            ].join(":")
          ].join(" ")

        sessionViewData = sessions.map( (session) ->
          {
            id: session.attributes.id,
            name: session.attributes.name,
            start: printTime(session.attributes.startTimestamp)
            end: printTime(session.attributes.endTimestamp)
          }
        )
        res.render 'sessions', sessions: sessionViewData
      )
