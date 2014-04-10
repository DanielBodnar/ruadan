Session = require("../../app/models/session.coffee")

MAX_AGE = 14 * 24 * 60 * 60 * 1000 # ms (2 weeks)

deleteOldSessions = ->
  now = new Date().getTime()
  Session.all().then( (sessions) ->
    sessions.filter( (session) -> session.isEnded() )
            .filter( (session) -> now - session.attributes.endTimestamp > MAX_AGE )
            .forEach( (session) -> session.delete() )
  )

module.exports = deleteOldSessions

