DocumentNode = require("./document_node.coffee")
DocumentTypeNode = require("./document_type_node.coffee")
CommentNode = require("./comment_node.coffee")
TextNode = require("./text_node.coffee")
ElementNode = require("./element_node.coffee")
Window = require("window")

class Deserializer

  @NODE_TYPE_MAP: {}

  @NODE_TYPE_MAP[Window.Node.DOCUMENT_NODE] = DocumentNode
  @NODE_TYPE_MAP[Window.Node.DOCUMENT_TYPE_NODE] = DocumentTypeNode
  @NODE_TYPE_MAP[Window.Node.COMMENT_NODE] = CommentNode
  @NODE_TYPE_MAP[Window.Node.TEXT_NODE] = TextNode
  @NODE_TYPE_MAP[Window.Node.ELEMENT_NODE] = ElementNode

  @nodeFromJson: (json) ->
    return null unless json

    NodeType = @NODE_TYPE_MAP[json.type]
    return null unless NodeType

    NodeType.fromJson(json)

  @nodeTreeFromJson: (rootJson) ->
    node = @nodeFromJson(rootJson)
    for child in rootJson.childNodes
      node.addChild(@nodeTreeFromJson(child))
    node

  @deserializeSubTree: (document, rootNode, nodeMap) ->
    return null unless rootNode

    domNode = rootNode.toDomNode(document)
    nodeMap.setNode(domNode, rootNode.getId()) if nodeMap

    children = rootNode.getChildren()
    for child in children
      domChild = @deserializeSubTree(document, child, nodeMap)
      domNode.appendChild(domChild)
    domNode

module.exports = Deserializer
