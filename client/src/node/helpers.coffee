class Helpers
  @serializeAttributes: (domNode) ->
    attributes = {}
    return attributes unless domNode.attributes

    for attribute in domNode.attributes
      attributes[attribute.name] = attribute.value if attribute.specified

    if domNode.tagName.toLowerCase() == "img"
      attributes["src"] = domNode.src

    if domNode.tagName.toLowerCase() == "link"
      attributes["href"] = domNode.href

    attributes

  @serializeStyle: (domNode) ->
    # RECORDING COMPUTED STYLE:
    # During a CSS transition, getComputedStyle returns the original property value in Firefox,
    # but the final property value in WebKit.
    #      computedStyle = @_serializeCSSStyleDeclaration(getComputedStyle(node))
    #      inlineStyle = @_serializeCSSStyleDeclaration(node.style)
    #      result = _.extend({}, computedStyle, inlineStyle)
    #      result

    # We only save inline style for now
    style = domNode.style
    result = {}
    return result unless style

    for i in [0...style.length]
      key = style[i]
      value = style[key]
      result[key] = value if value?
    result

module.exports = Helpers
