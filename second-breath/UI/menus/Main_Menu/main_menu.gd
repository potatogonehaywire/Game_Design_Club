class_name MainMenu
extends Control

#Start Button
@onready var start_button : Button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button
#Exit Button
@onready var exit_button : Button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button
#Option button
@onready var option_button :Button = $MarginContainer/HBoxContainer/VBoxContainer/Option_button
@onready var option_menu : OptionsMenu = $Options_menu
@onready var margin_container : MarginContainer = $MarginContainer

@onready var start_level: PackedScene = preload("uid://ckk0uk57jofg2")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handle_connecting_signal()


func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)


func on_options_pressed() -> void:
	margin_container.visible = false
	option_menu.set_process(true)
	option_menu.visible = true


func on_exit_pressed() -> void:
	get_tree().quit()


func on_exit_option_menu() -> void:
	margin_container.visible = true
	option_menu.visible = false


func handle_connecting_signal() -> void:
	start_button.button_down.connect(on_start_pressed)
	option_button.button_down.connect(on_options_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	option_menu.exit_option_menu.connect(on_exit_option_menu)
