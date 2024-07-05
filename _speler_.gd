extends PathFollow3D
@onready var play = $play
var secondsElapsed=1
@onready var time = $time



func _on_timer_timeout():
	if !time==null:
		secondsElapsed+=1
		time.start()
		


func _on_end_body_entered(body):
	
	body.can_move=false
	time.stop()
	play.speed_scale/=secondsElapsed
	print(play.speed_scale," ",secondsElapsed)
	time.queue_free()
	play.play("progress")
	await play.animation_finished
	get_tree().quit()

