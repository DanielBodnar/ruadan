Node = require('./node.coffee')


makeHidden = (domNode) ->
  domNode.style.setProperty('display', 'none', 'important')
  domNode.style.setProperty('visibility', 'hidden', 'important')
  domNode
class ElementNode extends Node
  _createDomNode: (document) ->
    domNode = null

    switch (@data.tagName)
      when 'HTML', 'HEAD', 'BODY'
        domNode = document.getElementsByTagName(@data.tagName)[0]
        break
      when 'IFRAME'
        domNode = document.createElement('div')
        domNode.style.visibility = "hidden !important"; #trying to see how it'll look
        domNode
        break
      when 'SCRIPT'
        domNode = document.createElement('noscript')
        makeHidden(domNode)
        break
      when 'NOSCRIPT'
        domNode = document.createElement(@data.tagName)
        makeHidden(domNode)
        break
      else
        domNode = document.createElement(@data.tagName)
        break

    domNode

module.exports = ElementNode
