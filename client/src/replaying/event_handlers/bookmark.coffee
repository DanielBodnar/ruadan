EventHandler = require('./event_handler.coffee')
BookmarkEvent = require('../../events/bookmark.coffee')

class Bookmark extends EventHandler
  action: BookmarkEvent::action

  constructor: () ->

module.exports = Bookmark
