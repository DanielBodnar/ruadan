module.exports = (app) ->
  class app.ApplicationController

    @index = (req, res) ->
      res.render 'index', { bookmarkletSource: require('fs').readFileSync("app/assets/js/async_loader.js") }
