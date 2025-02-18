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
	state.travel(state.ActionState.READY)

func _check_resource_costs() -> bool:
	for cost in costs:
		if entity.resources.get_by_type(cost.type).current_amount < cost.amount:
			return false
	return true

func _physics_process(delta: float) -> void:
	match state.current_state:
		state.ActionState.READY:
			_on_actionstate_ready()
		state.ActionState.BLOCKED:
			_on_actionstate_blocked()
		state.ActionState.PREPARING:
			_on_actionstate_preparing(delta)
		state.ActionState.CASTING:
			_on_actionstate_casting(delta)
		state.ActionState.COOLDOWN:
			_on_actionstate_cooldown()

func _on_actionstate_ready():
	pass

func _on_actionstate_blocked():
	pass

func _on_actionstate_preparing(delta:float):
	pass

func _on_actionstate_casting(delta:float):
	pass

func _on_actionstate_cooldown():
	pass
