Node = require('./node.coffee')

class DocumentTypeNode extends Node
  _createDomNode: (document) ->
    document.createDocumentType(
      null,
      @data.publicId,
      @data.systemId
    )

module.exports = DocumentTypeNode
