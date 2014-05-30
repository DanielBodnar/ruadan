Event = require('../event.coffee')

class CharacterData extends Event
  action: "characterDataMutation"

  constructor: (nodeId, oldData, newData, timestamp) ->
    super({
      nodeId: nodeId,
      oldData: oldData,
      newData: newData
    }, timestamp)

module.exports = CharacterData
