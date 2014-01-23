page = require('webpage').create()

page.zoomFactor = 1
renderCurrentViewport = (page, scroll, filename) ->
  viewportSize = page.viewportSize;

  page.clipRect =
    top: scroll.y
    left: scroll.x
    height: viewportSize.height
    width: viewportSize.width

  console.log(page.render(filename))
  phantom.exit()


page.onCallback = (data)->
  page.viewportSize =
    width: data.viewport.width
    height: data.viewport.height
  renderCurrentViewport(page, data.scroll, 'capture.png')

page.onLoadFinished = (stat)->


#  page.setContent(data.html, 'http://127.0.0.1:3000/replay')

#  page.scrollPosition = {
#    top: data.scroll.y
#    left: data.scroll.x
#  }





page.onError = (msg, trace) ->
  console.log("error", msg)
  trace.forEach((item)->
    console.log('  ', item.file, ':', item.line);
  )

page.open('http://127.0.0.1:3000/replay', (a)->
  console.dir("loaded", a)

)




