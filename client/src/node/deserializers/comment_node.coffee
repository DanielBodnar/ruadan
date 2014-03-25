Node = require('./node.coffee')

class CommentNode extends Node
  _createDomNode: (document) ->
    document.createComment(@data.textContent)

module.exports = CommentNode
