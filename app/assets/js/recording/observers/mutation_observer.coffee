define([
  'lodash'
  'eventEmitter'
],(
  _
  EventEmitter
)->
  class MutationObserver extends EventEmitter
    constructor: ()->
      MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver
      @observer = new MutationObserver((mutations)=>@_onChange(mutations))

    observe: (el, options = {})->
      defaultOptions =
        childList: true
        attributes: true
        characterData: true
        subtree: true
        attributeOldValue: true
        characterDataOldValue: true
        cssProperties: true
        cssPropertyOldValue: true
        attributeFilter: []

      @observer.observe(el, _.extend(defaultOptions, options))

    disconnect: ->
      @observer.disconnect()

    _onChange: (mutations)->
      @trigger('change', [mutations])
)
