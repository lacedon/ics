extends Node
class_name WithStateMachine

signal beforeStateChanged(newState: State, currentState: State)
signal stateChanged(currentState: State, oldState: State)

@export var state: State

func changeState(newState: State):
  emit_signal('beforeStateChanged', newState, state)

  var oldState: State = state
  if (state): state.deactivate(newState)
  state = newState
  state.activate(oldState)

  emit_signal('stateChanged', state, oldState)

func _ready():
  await get_parent().ready
  changeState(state)
