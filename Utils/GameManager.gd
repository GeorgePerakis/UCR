extends Node

signal enemy_spawned
signal enemy_died

var player_deaths := 0
var enemy_deaths := 0
var enemy_spawns := 0
var current_enemy_ammount := 0

func reset():
	player_deaths = 0
	enemy_deaths = 0
	enemy_spawns = 0
	current_enemy_ammount = 0
