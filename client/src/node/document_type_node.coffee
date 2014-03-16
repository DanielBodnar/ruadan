Node = require("./node.coffee")

class DocumentTypeNode extends Node
  type: Node.types.DOCUMENT_TYPE_NODE

  @_getNodeData: (domNode) ->
    {
      publicId: domNode.publicId,
      systemId: domNode.systemId
    }

module.exports = DocumentTypeNode
