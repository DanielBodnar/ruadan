module.exports = (app) ->
  class app.ApplicationController

    initialMutationState: {}
    initialScrollState: {}
    initialMousePosition: {}
    initialViewportState: {}

    # GET /
    @index = (req, res) ->
      res.render 'index'

    @record = (req, res) ->
      switch req.body.action
        when "initialMutationState"
          @initialMutationState = req.body.data
          break
        when "initialScrollState"
          @initialScrollState = req.body.data
          break
        when "initialViewportState"
          @initialViewportState = req.body.data
          break
        else
          console.log("not found #{req.body.action}")

      res.json {
        initialMutationState: @initialMutationState
        initialScrollState: @initialScrollState
        initialMousePosition: @initialMousePosition
        initialViewportState: @initialViewportState
      }

    @view = (req, res) ->
      res.json {
        initialMutationState: @initialMutationState
        initialScrollState: @initialScrollState
        initialMousePosition: @initialMousePosition
        initialViewportState: @initialViewportState
      }

    @replay = (req, res)->
      res.render 'replay',
      {
        initialMutationState: @initialMutationState
        initialScrollState: @initialScrollState
        initialMousePosition: @initialMousePosition
        initialViewportState: @initialViewportState
      }

