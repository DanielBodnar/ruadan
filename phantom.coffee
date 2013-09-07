page = require('webpage').create()

page.onResourceRequested = (requestData, networkRequest)->

page.onCallback = (data)->
  page.viewportSize = { width: data.viewport.width, height: data.viewport.height }
  console.log(data.content)
  page.setContent(data.content, 'http://127.0.0.1:3000/replay')

  page.onLoadFinished=(stat)->
    console.log("finished", stat)
    console.log(page.render('capture.png'))
    setTimeout((-> phantom.exit()),5000)


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




