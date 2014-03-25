Event = require('./event.coffee')

class Bookmark extends Event
  action: "bookmark"

  constructor: (text, timestamp) ->
    super({ text: text }, timestamp)

module.exports = Bookmark
