ReplayHelpers = require('./replaying/helpers.coffee')
Player = require('./replaying/player/player.coffee')

module.exports = window.bootstrapReplayer = {
  start: (session, document)->
    ReplayHelpers.getEvents(session, (events) -> ReplayHelpers.doReplay(events, document))
  getEvents: ReplayHelpers.getEvents.bind(ReplayHelpers)
  prepareEvents: Player.prepareEvents.bind(ReplayHelpers)
}
