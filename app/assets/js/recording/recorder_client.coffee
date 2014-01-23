define([
  'lodash'
  'jquery'
], (
  _
  $
  Serializer
)->
  class RecorderClient

    constructor: (@document)->
    initialize: (@rootElement)->
    setInitialMutationState: (data)->
      @_record("initialMutationState", data)

    setInitialScrollState: (data)->
      @_record("initialScrollState", data)

    setInitialViewportState: (data)->
      @_record("initialViewportState", data)

    onMutation: (data)->
    onMouseMove: (data)->
    onScroll: (data) ->
      console.log("scroll", data)

    _record: (action, data) ->
      $.post("http://127.0.0.1:3000/record",{ action: action, data: data })
)
