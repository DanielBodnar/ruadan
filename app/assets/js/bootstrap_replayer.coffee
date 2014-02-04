define([
  'jquery'
  'replaying/deserializer'
],(
  $
  Deserializer
)->
  lastTime = 0;
  currentEventId = 0;
  events = null
  iframe = null
  mousePointer = null
  deserializer = null

  getNextEvent = -> events[currentEventId++]

  doEvent = (func, timestamp) ->
    setTimeout((=>
      func()
      handleEvent(getNextEvent())
    ), timestamp-lastTime)
    lastTime = timestamp

  handleEvent =  (event) ->
    return unless event
    if lastTime == 0
      lastTime = event.data.timestamp * 1

    switch event.action
      when "scroll"
        doEvent((->
          iframe.contentWindow.scrollTo(event.data.x, event.data.y)
        ), event.data.timestamp * 1)
        break
      when "mouse"
        doEvent((->
          mousePointer.style.left = "#{event.data.x}px";
          mousePointer.style.top = "#{event.data.y}px";
        ), event.data.timestamp * 1)
        break
      when "select"
        doEvent((->
          startNode = deserializer.idMap[event.data.anchorNode?.id]
          endNode = deserializer.idMap[event.data.focusNode?.id]

          return unless startNode && endNode

          range = destDocument.createRange()

          range.setStart(startNode, event.data.anchorOffset)
          range.setEnd(endNode, event.data.focusOffset)
          destDocument.getSelection().removeAllRanges()
          destDocument.getSelection().addRange(range)

        ), event.data.timestamp * 1)
        break
      when "mutation"
        doEvent((->
          event.data.forEach((data)->
            target = deserializer.idMap[data.targetNodeId]
            if (data.addedNodes)
              data.addedNodes.forEach((node)->
                deserializedNode = deserializer.deserialize(node, target)
                destDocument.adoptNode(deserializedNode)

                if data.nextSiblingId
                  sibling = deserializer.idMap[data.nextSiblingId]
                  target.insertBefore(deserializedNode, sibling)
                else if data.previousSiblingId
                  sibling = deserializer.idMap[data.previousSiblingId]
                  if sibling.nextSibling
                    target.insertBefore(deserializedNode, sibling.nextSibling)
                  else
                    target.appendChild(deserializedNode)
              )

            if (data.removedNodes)
              data.removedNodes.forEach((node)->
                if target
                  deserializedNode = deserializer.deserialize(node, target)
                  target.removeChild(deserializedNode)
                  deserializer.deleteNode(node)
                else
                  console.log("no target", event)
              )
          )
        ), event.data.timestamp * 1)
        break
      else
        console.log("unhandled event", event)
        handleEvent(getNextEvent())
        break


  mousePointer = document.getElementById("themouse")

  iframe = document.getElementById("theframe")
  destDocument = iframe.contentDocument



  $.get("http://127.0.0.1:3000/view", (data)->
    deserializer = new Deserializer(document)
    res = deserializer.deserialize(data.initialMutationState.nodes)

    newNode = destDocument.adoptNode(res)

    destDocument.replaceChild(newNode, destDocument.documentElement)

    iframe.contentWindow.scrollTo(data.initialScrollState.x, data.initialScrollState.y)
    iframe.setAttribute("width", "#{data.initialViewportState.width}")
    iframe.setAttribute("height", "#{data.initialViewportState.height}")
    iframe.setAttribute("frameborder", "0")

    iframe.style.width = "#{data.initialViewportState.width}px"
    iframe.style.height = "#{data.initialViewportState.height}px"

    events = data.events

    $(destDocument).ready(->
      handleEvent(getNextEvent())
    )
  )


)
