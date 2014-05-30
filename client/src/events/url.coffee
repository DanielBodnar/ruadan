Event = require('./event.coffee')

class Url extends Event
  action: "url"

  constructor: (oldUrl, newUrl, timestamp) ->
    super({
      oldUrl: oldUrl,
      newUrl: newUrl
    }, timestamp)

module.exports = Url

