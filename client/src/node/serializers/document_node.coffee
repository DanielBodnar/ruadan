Node = require("./node.coffee")

class DocumentNode extends Node
  type: Node.types.DOCUMENT_NODE

  @_getNodeData: (domNode) ->
    {
      url: domNode.url,
      alinkColor: domNode.alinkColor,
      dir: domNode.dir
    }

module.exports = DocumentNode
