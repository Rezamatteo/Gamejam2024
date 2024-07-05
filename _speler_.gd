extends PathFollow3D
@onready var play = $play
var secondsElapsed=1
@onready var time = $time

@onready var neck = $neck

@onready var cam = $neck/cam
var sensitivity = 3
func _on_timer_timeout():
	if !time==null:
		secondsElapsed+=1
		time.start()
		
func _input(event):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion:
		neck.rotate_y(-event.relative.x*0.01)
		cam.rotate_x(-event.relative.y*0.01)
		cam.rotation.x=clamp(cam.rotation.x,deg_to_rad(-90),deg_to_rad(90))
func _process(delta):
	var rota=Vector2.ZERO
	if Input.is_action_pressed("rightStickLeft"):
		rota.y+=1*delta
	if Input.is_action_pressed("rightStickRight"):
		rota.y-=1*delta
	if Input.is_action_pressed("rightStickDown"):
		rota.x-=0.65*delta
	if Input.is_action_pressed("rightStickUp"):
		rota.x+=0.65*delta
	neck.rotate_y(rota.y*sensitivity)
	cam.rotate_x(rota.x*sensitivity)
	cam.rotation.x=clamp(cam.rotation.x,deg_to_rad(-90),deg_to_rad(90))


func _enter_tree():
	for I in Global.points:
		get_parent().curve.add_point(I)
	await get_tree().create_timer(0.01).timeout
	time.stop()
	play.speed_scale/=secondsElapsed
	print(play.speed_scale," ",secondsElapsed)
	time.queue_free()
	play.play("progress")
	await play.animation_finished
	get_tree().quit()
