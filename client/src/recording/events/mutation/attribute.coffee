Event = require('../event.coffee')

class Attribute extends Event
  action: "attributeMutation"

  constructor: (elementId, attributeName, attributeNamespace, oldValue, newValue, timestamp) ->
    super({
      elementId: elementId,
      attributeName: attributeName,
      attributeNamespace: attributeNamespace,
      oldValue: oldValue,
      newValue: newValue
    }, timestamp)

module.exports = Attribute
