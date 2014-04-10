DocumentNode = require("./document_node.coffee")
DocumentTypeNode = require("./document_type_node.coffee")
CommentNode = require("./comment_node.coffee")
TextNode = require("./text_node.coffee")
ElementNode = require("./element_node.coffee")
Window = require("window")

class Serializer

  @NODE_TYPE_MAP: {}

  @NODE_TYPE_MAP[Window.Node.DOCUMENT_NODE] = DocumentNode
  @NODE_TYPE_MAP[Window.Node.DOCUMENT_TYPE_NODE] = DocumentTypeNode
  @NODE_TYPE_MAP[Window.Node.COMMENT_NODE] = CommentNode
  @NODE_TYPE_MAP[Window.Node.TEXT_NODE] = TextNode
  @NODE_TYPE_MAP[Window.Node.ELEMENT_NODE] = ElementNode

  @serializeNode: (domNode, nodeId) ->
    return null unless domNode

    NodeType = @NODE_TYPE_MAP[domNode.nodeType]
    return null unless NodeType

    serializedNode = NodeType.serialize(domNode)
    serializedNode.setId(nodeId)
    serializedNode

  @serializeSubTree: (rootNode, nodeMap) ->
    return null unless rootNode

    nodeId = nodeMap.registerNode(rootNode)
    serializedNode = @serializeNode(rootNode, nodeId)

    child = rootNode.firstChild
    while (child)
      serializedChild = @serializeSubTree(child, nodeMap)
      serializedNode.addChild(serializedChild)
      child = child.nextSibling

    serializedNode

module.exports = Serializer
