extends ActionInstance
class_name ActionOneshot

func _setup_states() -> void:
	state.ready_state.physics_processing.connect(_on_ready_processing)
	state.preparing_state.state_entered.connect(_on_preparing_state_entered)
	state.casting_state.state_entered.connect(_on_casting_entered)
	state.cooldown_state.state_entered.connect(_on_cooldown_entered)

func _on_preparing_state_entered() -> void:
	state.travel(state.casting_state)

func _on_ready_processing(delta) -> void:
	if Input.is_action_just_pressed(trigger):
		if _apply_resource_costs():
			state.travel(state.preparing_state)

func _on_casting_entered() -> void:
	print("Casting Testskill")
	state.travel(state.cooldown_state)

func _on_cooldown_entered() -> void:
	cooldown_timer.start()
