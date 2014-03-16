Node = require("./node.coffee")

class TextNode extends Node
  type: Node.types.TEXT_NODE

  @_getNodeData: (domNode) ->
    {
      textContent: domNode.textContent
    }

module.exports = TextNode
