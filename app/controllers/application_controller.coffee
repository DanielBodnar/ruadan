module.exports = (app) ->
  events = []
  initialMutationState =  {}
  initialScrollState = {}
  initialMousePosition = {}
  initialViewportState = {}

  class app.ApplicationController
    # GET /
    @index = (req, res) ->
      res.render 'index'

    @record = (req, res) ->
      switch req.body.action
        when "initialMutationState"
          initialMutationState = JSON.parse(req.body.data)
          break
        when "initialScrollState"
          initialScrollState = JSON.parse(req.body.data)
          break
        when "initialViewportState"
          initialViewportState = JSON.parse(req.body.data)
          break
        else
          val = {action: req.body.action, data: JSON.parse(req.body.data)}
          events.push(val)

      res.json {}

    @view = (req, res) ->
      res.json {
        initialMutationState: initialMutationState
        initialScrollState: initialScrollState
        initialMousePosition: initialMousePosition
        initialViewportState: initialViewportState
        events: events
      }

    @replay = (req, res)->
      res.render 'replay',
      {
        initialMutationState: initialMutationState
        initialScrollState: initialScrollState
        initialMousePosition: initialMousePosition
        initialViewportState: initialViewportState
        event: events
      }

