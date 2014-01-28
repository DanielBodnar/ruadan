class MutationObserver
  initialize: ->

  observe: ->

  _onChange: (mutations)->

  _handleMutation: (mutation)->
    console.log("mutation", mutation)




listenToEvents = ->
  MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver
  observer = new MutationObserver((mutations)-> mutations.forEach(console.log))
  options =
    childList: true #Set to true if mutations to target's children are to be observed.
    attributes: true #Set to true if mutations to target's attributes are to be observed.
    characterData: true #Set to true if mutations to target's data are to be observed.
    subtree: true #Set to true if mutations to not just target, but also target's descendants are to be observed.
    attributeOldValue: true #Set to true if attributes is set to true and target's attribute value before the mutation needs to be recorded.
    characterDataOldValue: true #Set to true if characterData is set to true and target's data before the mutation needs to be recorded.
    cssProperties: true #Set to true if mutations to target's CSS properties are to be observed.
    cssPropertyOldValue: true #Set to true if cssProperties is set to true and target's cssProperty value before the mutation needs to be recorded.
    cssPropertyFilter: [] #Set to a list of CSS property names if not all CSS property mutations need to be observed.
    attributeFilter: [] #Set to an array of attribute local names (without namespace) if not all attribute mutations need to be observed.

  observer.observe(@element, options)