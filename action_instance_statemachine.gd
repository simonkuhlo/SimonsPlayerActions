class_name ActionStateMachine

enum ActionState {BLOCKED, READY, PREPARING, CASTING, COOLDOWN}
var current_state:ActionState = ActionState.BLOCKED

signal action_state_changed(new_state:ActionState)

func travel(new_state:ActionState):
	current_state = new_state
	action_state_changed.emit(current_state)
