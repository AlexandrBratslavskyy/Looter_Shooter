@tool
extends StaticBody3D

@onready var shader: ShaderMaterial = $MeshInstance3D.get_active_material(0)
@export_color_no_alpha var color: Color:
	set(value):
		color = value
		if Engine.is_editor_hint():
			_update_mesh()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_mesh()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass

func _update_mesh() -> void:
	shader.set_shader_parameter("color", color)

func take_damage() -> void:
	print("box " + color.to_html())
