ReplayHelpers = require('./replaying/helpers.coffee')
Simulator = require('./replaying/player/replay_simulator.coffee')
Player = require('./replaying/player/player.coffee')

module.exports = window.bootstrapPhantom = {
  getEvents: (session, cb)->
    ReplayHelpers.getEvents(session, cb)
  Simulator: Simulator
  prepareEvents: (events)->
    Player.prepareEvents(events)
}
