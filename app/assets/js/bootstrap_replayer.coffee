define([
  'jquery'
  'replaying/deserializer'
],(
  $
  Deserializer
)->
  $.get("http://127.0.0.1:3000/view", (data)->
    deserializer = new Deserializer(document.getElementsByTagName("iframe")[0].contentWindow.document)
    deserializer.deserialize(data.nodes)
    html = document.getElementsByTagName("iframe")[0].contentWindow.document.getElementsByTagName("html")[0].innerHTML
    initialState =
      content: html
      viewport:
        width: data.viewport.width
        height: data.viewport.height

    window.callPhantom(initialState) if window.callPhantom
  )
)
