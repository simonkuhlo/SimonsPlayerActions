extends ActionInstance
class_name ActionToggle

@export var costs_per_second:Array[ObtainableResourceCost] = []

func _setup_states() -> void:
	state.missing_resource_state.physics_processing.connect(_on_missing_resource_processing)
	state.ready_state.physics_processing.connect(_on_ready_processing)
	state.preparing_state.state_entered.connect(_on_preparing_state_entered)
	state.casting_state.physics_processing.connect(_on_casting_processing)
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

func _on_casting_processing(delta:float) -> void:
	if _apply_cost_per_second(delta):
		_cast()
	else:
		state.travel(state.missing_resource_state)
	if Input.is_action_just_pressed(trigger):
		state.travel(state.cooldown_state)

func _on_cooldown_entered() -> void:
	cooldown_timer.start()

func _cast() -> void:
	print("Casting Testskill")

func _apply_cost_per_second(delta:float) -> bool:
	for cost in costs_per_second:
		var entity_resource:ObtainableResource = entity.resources.get_resource_by_type(cost.type)
		if !entity_resource:
			return false
		if entity_resource.current_value < cost.amount * delta:
			return false
		entity_resource.current_value -= cost.amount * delta
	return true
