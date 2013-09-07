define([
  'lodash'
], (
  _
)->
  class Deserializer
    constructor: (@root, @idMap={}) ->

    deserialize: (nodeData, parent = @root)->
      return null unless nodeData?
      node = @idMap[nodeData.id]
      return node if node?

      switch nodeData.nodeType
        when "#{Node.COMMENT_NODE}"
          node = @root.createComment(nodeData.textContent)
          break
        when "#{Node.TEXT_NODE}"
          node = @root.createTextNode(nodeData.textContent)
          break
        when "#{Node.DOCUMENT_TYPE_NODE}"
          node = @root.implementation.createDocumentType(
              nodeData.name,
              nodeData.publicId,
              nodeData.systemId)
          break
        when "#{Node.ELEMENT_NODE}"
          switch nodeData.tagName
            when 'HTML'
              node = @root.getElementsByTagName("html")[0]
              break
            when 'HEAD'
              node = @root.getElementsByTagName("head")[0]
              break
            when 'BODY'
              node = @root.getElementsByTagName("body")[0]
              break
            when 'LINK'
              node = @_createElement("style")
              href = nodeData.attributes["href"]
              nodeData.attributes["xhref"] = href
              delete nodeData.attributes["href"]
              node.innerHTML = nodeData.styleText
            else
              node = @_createElement(nodeData.tagName)
          @_addAttributes(node, nodeData.attributes)
      @_addStyle(node, nodeData.styles)
      throw "ouch" unless node
      @idMap[nodeData.id] = node

      switch nodeData.tagName
        when 'HTML', 'HEAD', 'BODY'
          break;
        else
          parent.appendChild(node) if parent
      if nodeData.childNodes?
        for child in nodeData.childNodes
          @deserialize(child, node)
      node



    _createElement: (tagName)->
      switch tagName
        when 'SCRIPT'
          node = @root.createElement('NO-SCRIPT')
          node.style.display = 'none'
          break
#        when 'HEAD'
#          node = parent.createElement('HEAD')
#         node.appendChild(document.createElement('BASE'))
#         node.firstChild.href = base
          break
        else
          node = @root.createElement(tagName)
          break
      node

    _addAttributes: (node, attributes)->
      _.each(attributes, (value, key)->
        node.setAttribute(key, value) unless _.isEmpty(value)
      )
      node

    _addStyle: (node, styles)->
      _.each(styles, (value, key) ->
        node.style[value[0]] = value[1]
      )



)
