extends PathFollow3D
@onready var play = $play
var secondsElapsed=1
@onready var time = $time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("run"):
		time.stop()
		play.speed_scale/=secondsElapsed
		print(play.speed_scale," ",secondsElapsed)
		play.play("progress")
		secondsElapsed=0
		time.start()


func _on_timer_timeout():
	secondsElapsed+=1
	time.start()
	
