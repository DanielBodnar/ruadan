_ =
OBSERVERS = [
  require('./mutation_observer.coffee')
  require('./mouse_observer.coffee')
  require('./scroll_observer.coffee')
  require('./viewport_observer.coffee')
  require('./text_selection_observer.coffee')
  require('./url_observer.coffee')
  require('./visibility_observer.coffee')
  require('./focus_observer.coffee')
  require('./window_close_observer.coffee')
]


_unbindObserverEvents= (observers) ->
  for observer in observers
    observer.unbindAllEvents()
    observer.disconnect()

_bindObserversEvents= (observers, cb)->
  for observer in observers
    observer.bindAllEvents(cb)

class ObserverManager
  constructor: (window, rootElement, nodeMap)->
    @observers = []
    for observer in OBSERVERS
      data = {
        window: window
        nodeMap:nodeMap
        element: rootElement
      }
      newObserver = new observer(data)
      @observers.push(newObserver)

  start: (cb)->
    _bindObserversEvents(@observers, cb)
    observer.observe() for observer in @observers

  stop: ->
    _unbindObserverEvents(@observers)
    observer.disconnect() for observer in @observers



module.exports = ObserverManager