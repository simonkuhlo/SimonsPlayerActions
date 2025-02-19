extends ActionInstance
class_name ActionContinuous

func _setup_states() -> void:
	state.missing_resource_state.physics_processing.connect(_on_missing_resource_processing)
	state.ready_state.physics_processing.connect(_on_ready_processing)
	state.preparing_state.state_entered.connect(_on_preparing_state_entered)
	state.casting_state.state_entered.connect(_on_casting_entered)
	state.cooldown_state.state_entered.connect(_on_cooldown_entered)

func _on_missing_resource_processing(delta) -> void:
	print("Missing Resources!")
	if _check_resource_costs():
		state.travel(state.ready_state)

func _on_ready_processing(delta) -> void:
	if !_check_resource_costs():
		state.travel(state.missing_resource_state)
		return
	if Input.is_action_just_pressed(trigger):
		if _apply_resource_costs():
			state.travel(state.preparing_state)

func _on_preparing_state_entered() -> void:
	state.travel(state.casting_state)

func _on_casting_entered() -> void:
	_cast_oneshot()
	state.travel(state.cooldown_state)

func _on_cooldown_entered() -> void:
	cooldown_timer.start()

func _cast_oneshot() -> void:
	print("Casting Testskill")
