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
#      console.log(req.body)
      switch req.body.action
        when "initialMutationState"
          initialMutationState = req.body.data[0]
          break
        when "initialScrollState"
          initialScrollState = req.body.data[0]
          break
        when "initialViewportState"
          initialViewportState = req.body.data[0]
          break
        else
          val = {action: req.body.action, data: req.body.data[0]}
          events.push(val)

#      console.log(req.body.data[0])
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

