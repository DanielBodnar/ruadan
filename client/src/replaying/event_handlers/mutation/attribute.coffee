EventHandler = require('../event_handler.coffee')
AttributeEvent = require('../../../events/mutation/attribute.coffee')

class Attribute extends EventHandler
  action: AttributeEvent::action

  constructor: (@nodeMap) ->

  handle: (event) ->
    element = @nodeMap.getNode(event.data.elementId)
    element.setAttribute(event.data.attributeName, event.data.newValue)


module.exports = Attribute
