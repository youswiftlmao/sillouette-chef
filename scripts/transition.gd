extends CanvasLayer



@onready var anim = $AnimationPlayer


func _ready():
	anim.play("fade")  # 🔥 THIS FIXES IT


func fade_to_scene(path: String):
	anim.play("fadeout")
	await anim.animation_finished
	
	get_tree().change_scene_to_file(path)
	
	anim.play("fade")
	
func reset_scene():
	fade_to_scene(get_tree().current_scene.scene_file_path)
