extends PathFollow3D
@onready var play = $play


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("run"):
		play.play("progress")
