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
	move_and_slide()

func jump():
	velocity.y = speed

func fall():
	var g = get_gravity()
	var dt = get_physics_process_delta_time()
	velocity.y += g.y * dt
