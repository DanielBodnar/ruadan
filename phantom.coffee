page = require('webpage').create()

page.onResourceRequested = (requestData, networkRequest)->
currentPage = "initial"

page.onCallback = (data)->
  page.viewportSize = { width: data.viewport.width, height: data.viewport.height }
  currentPage = "inner"
  page.setContent(data.content, 'http://127.0.0.1:3000/replay')

  page.onLoadFinished=(stat)->
    console.log("finished", stat)
    console.log("render", page.render('capture.png'))
    console.log(page.frameUrl)
    phantom.exit()

  page.onError = (msg, trace) ->
    console.log(msg)
    trace.forEach((item)->
      console.log('  ', item.file, ':', item.line);
    )

page.open('http://127.0.0.1:3000/replay', ->

#  page.evaluate(->
#    define(['http://127.0.0.1:3000/build/bootstrap_replayer.js'], (A)->
#      A.work()
#    )
#  )

#  console.log(page.childFramesCount())
#  page.switchToFrame(1).
#

)




