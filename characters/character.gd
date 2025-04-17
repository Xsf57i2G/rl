class_name Character extends CharacterBody3D

var dead = false
var hp = 1
var jumps = 2
var speed = 5
var acceleration = 25

func hurt(n):
	if dead:
		return
	hp -= n
	if hp <= 0:
		dead = true

func move(d):
	var dt = get_process_delta_time()
	velocity = velocity.move_toward(Vector3(d.x * speed, velocity.y, d.z * speed), acceleration * dt)
	lean(d)
	move_and_slide()

func jump():
	velocity.y = speed

func fall():
	var g = get_gravity()
	var dt = get_process_delta_time()
	velocity.y += g.y * dt


func lean(d):
	var a = 0.2
	var s = 10.0
	var dt = get_process_delta_time()
	var to = -d.x * a
	$Character.rotation.z = lerp($Character.rotation.z, to, s * dt)
