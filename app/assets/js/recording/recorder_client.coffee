define([
  'jquery'
], (
  $
)->
  class RecorderClient
    constructor: (@document, @rootElement)->

    setInitialMutationState: (data)->
      @_record("initialMutationState", data)

    setInitialScrollState: (data)->
      @_record("initialScrollState", data)

    setInitialViewportState: (data)->
      @_record("initialViewportState", data)

    setInitialSelection: (selection)->
      @_record("initialSelectState", selection)

    onSelect: (selection) ->
      @_record("select", selection)

    onMutation: (data)->
      @_record("mutation", data)



    onMouseMove: (data)->
      @_record("mouse", data)

    onScroll: (data) ->
      @_record("scroll", data)

    _record: (action, data) ->
      console.log("recording ",action)
      $.post("http://127.0.0.1:3000/record", { action: action, data: JSON.stringify(data) })
)
