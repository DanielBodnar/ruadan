Node = require("./node.coffee")

class CommentNode extends Node
  type: Node.types.COMMENT_NODE

  @_getNodeData: (domNode) ->
    {
      textContent: domNode.textContent
    }

module.exports = CommentNode
