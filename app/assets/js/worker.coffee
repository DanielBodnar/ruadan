done = ->
  postMessage "done"

onmessage = (e) ->
  done() if e.data == "start"
