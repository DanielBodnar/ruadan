module.exports = (app) ->
  class app.PhantomController
    @index = (req, res) ->
      res.render 'phantom', sessionId: req.params.sessionId