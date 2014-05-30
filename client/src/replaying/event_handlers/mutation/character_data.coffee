EventHandler = require('../event_handler.coffee')
CharacterDataEvent = require('../../../events/mutation/character_data.coffee')

class CharacterData extends EventHandler
  action: CharacterDataEvent::action

  constructor: (@nodeMap) ->

  handle: (event) ->
    node = @nodeMap.getNode(event.data.nodeId)
    node.textContent = event.data.newData

module.exports = CharacterData
