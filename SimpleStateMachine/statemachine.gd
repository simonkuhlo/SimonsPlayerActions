extends Node
class_name ActionStateMachine


var blocked_state:StateMachineState = StateMachineState.new()
var ready_state:StateMachineState = StateMachineState.new()
var preparing_state:StateMachineState = StateMachineState.new()
var casting_state:StateMachineState = StateMachineState.new()
var cooldown_state:StateMachineState = StateMachineState.new()

var current_state:StateMachineState = blocked_state

func travel(new_state:StateMachineState) -> void:
	current_state.state_exited.emit()
	current_state = new_state
	current_state.state_entered.emit()

func _physics_process(delta:float) -> void:
	current_state.physics_processing.emit(delta)
