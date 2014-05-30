Node = require('./node.coffee')

class DocumentNode extends Node
  _createDomNode: (document) ->
    document.implementation.createHTMLDocument()

module.exports = DocumentNode
