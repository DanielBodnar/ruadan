Node = require("./node.coffee")

class ElementNode extends Node
  type: Node.types.ELEMENT_NODE

  @_getNodeData: (domNode) ->
    {
      tagName: domNode.tagName
    }

module.exports = ElementNode
