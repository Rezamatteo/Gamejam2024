extends PathFollow3D
@onready var play = $play
var secondsElapsed=0
@onready var time = $time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("run"):
		time.stop()
		play.speed_scale=1/secondsElapsed
		play.play("progress")


func _on_timer_timeout():
	secondsElapsed+=1
	time.start()
	
