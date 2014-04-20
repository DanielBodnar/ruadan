EventEmitter = require('eventemitter').EventEmitter

###
  Base Observer class, each observer should inherit from this class, so each observer has the same
  data available to it, it might choose which to use.
  This class also should include common behaviour across observers
###
class BaseObserver extends EventEmitter
  ###
    Public: Initialize a Observer

    data - The object of params to be available to each observer,not all params applicable to all observers,
      currently supported params:
            window - The window object
            nodeMap - The NodeMap nodes manager
            element - The root element we're observing
  ###
  constructor: (data)->
    @document = data.window.document
    @window = data.window
    @nodeMap = data.nodeMap
    @element = data.element

  bindAllEvents: (cb)->
    for event in @EVENTS
      @on(event, cb)

  unbindAllEvents: ->
    for event in @EVENTS
      @removeAllListeners(event)


module.exports = BaseObserver