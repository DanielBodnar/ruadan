Node = require('./node.coffee')

class TextNode extends Node
  _createDomNode: (document) ->
    document.createTextNode(@data.textContent)

module.exports = TextNode
