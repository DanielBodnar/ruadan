worker = new Worker("worker.js")

# Watch for messages from the worker
worker.onmessage = (e) ->
  e.data

worker.postMessage "start"
