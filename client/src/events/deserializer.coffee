MouseClickEvent = require('./mouse/click.coffee')
MousePositionEvent = require('./mouse/position.coffee')

MutationAddNodesEvent = require('./mutation/add_nodes.coffee')
MutationAttributeEvent = require('./mutation/attribute.coffee')
MutationCharacterDataEvent = require('./mutation/character_data.coffee')
MutationRemoveNodesEvent = require('./mutation/remove_nodes.coffee')

BookmarkEvent = require('./bookmark.coffee')
NewPageEvent = require('./new_page.coffee')
ScrollEvent = require('./scroll.coffee')
SelectionEvent = require('./selection.coffee')
UrlEvent = require('./url.coffee')
ViewportEvent = require('./viewport.coffee')
VisibilityEvent = require('./visibility.coffee')
FocusEvent = require('./focus.coffee')
WindowCloseEvent = require('./window_close.coffee')

class Deserializer

  @EVENTS: {}
  @EVENTS[MouseClickEvent::action] = MouseClickEvent
  @EVENTS[MousePositionEvent::action] = MousePositionEvent

  @EVENTS[MutationAddNodesEvent::action] = MutationAddNodesEvent
  @EVENTS[MutationAttributeEvent::action] = MutationAttributeEvent
  @EVENTS[MutationCharacterDataEvent::action] = MutationCharacterDataEvent
  @EVENTS[MutationRemoveNodesEvent::action] = MutationRemoveNodesEvent

  @EVENTS[BookmarkEvent::action] = BookmarkEvent
  @EVENTS[NewPageEvent::action] = NewPageEvent
  @EVENTS[ScrollEvent::action] = ScrollEvent
  @EVENTS[SelectionEvent::action] = SelectionEvent
  @EVENTS[UrlEvent::action] = UrlEvent
  @EVENTS[ViewportEvent::action] = ViewportEvent
  @EVENTS[VisibilityEvent::action] = VisibilityEvent
  @EVENTS[FocusEvent::action] = FocusEvent
  @EVENTS[WindowCloseEvent::action] = WindowCloseEvent

  @deserialize: (eventJson) ->
    @EVENTS[eventJson.action].fromJson(eventJson) if (@EVENTS[eventJson.action])

module.exports = Deserializer
