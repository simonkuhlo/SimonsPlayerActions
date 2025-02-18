extends Node
class_name ActionInstance

@export var entity:Node
@export var trigger:StringName

@export var prepare_time:float = 0
@export var cooldown:float = 0

@export var costs:Array[ObtainableResourceCost] = []

var state:ActionStateMachine = ActionStateMachine.new()

var cooldown_timer:Timer = Timer.new()

## Emitted when the action gets prepared
signal prepare
## Emitted when the action gets casted
signal cast
## Emitted when the action ends
signal end

func _ready() -> void:
	cooldown_timer.one_shot = true
	cooldown_timer.autostart = false
	if cooldown:
		cooldown_timer.wait_time = cooldown
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	add_child(cooldown_timer)
	add_child(state)
	_setup_states()
	state.travel(state.ready_state)

func _setup_states() -> void:
	pass

func _on_cooldown_timer_timeout() -> void:
	state.travel(state.ready_state)

func _apply_resource_costs() -> bool:
	for cost in costs:
		var entity_resource:ObtainableResource = entity.resources.get_resource_by_type(cost.type)
		if !entity_resource:
			return false
		if entity_resource.current_value < cost.amount:
			return false
		entity_resource.current_value -= cost.amount
	return true
