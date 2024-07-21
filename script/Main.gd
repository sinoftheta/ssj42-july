extends Node2D

@export var game_scene: PackedScene

################################################################################
## MENU LOGIC
################################################################################

var menu_history:Array[Menu] = [Menu.none, Menu.main]
func _ready() -> void:
	show_menu(current_menu())

func current_menu() -> Menu:
	return menu_history[-1]
func prev_menu() -> Menu:
	return menu_history[-2]
func pop_menu(n:int = 1) -> void:

	#if menu_history.size() - n < 2 idk, somethin
	if menu_history.size() == 2:
		## Menu history cannot be smaller than 2
		return
	hide_menu(current_menu())
	for i:int in range(n):
		menu_history.pop_back()
	show_menu(current_menu())

func push_menu(menu:Menu, level:int = 0) -> void:

	## Special cases where we are pushing to gameplay
	match menu:
		Menu.gameplay:
			pass
			$Level.add_child(game_scene.instantiate())
		_:
			$Level.remove_child($Level.get_child(0))

	hide_menu(current_menu())
	menu_history.push_back(menu)
	show_menu(current_menu())

################################################################################
## MENU VISIBILITY
################################################################################
func show_menu(menu:Menu, level:int = -1) -> void:

	%MenuBack.visible = not menu_attributes[menu].gameplay_visible

	if menu_attributes[menu].node:
		menu_attributes[menu].node.visible = true

	if get_tree().paused != menu_attributes[menu].pause_engine:
		get_tree().paused = menu_attributes[menu].pause_engine

func hide_menu(menu:Menu) -> void:
	if menu_attributes[menu].node:
		menu_attributes[menu].node.visible = false

################################################################################
## MENU NAV BUTTON HOOKS
################################################################################
func _on_options_pressed() -> void:
	push_menu(Menu.options)
func _on_back_pressed() -> void:
	pop_menu()
func _on_quit_pressed() -> void:
	get_tree().quit()
func _on_editor_pause_pressed() -> void:
	push_menu(Menu.level_pause)

################################################################################
## SPECIAL MENU NAV BUTTON HOOKS
################################################################################

func _on_return_to_menu_pressed() -> void:
	#editor.clear_level_data()
	## pop TWO menus in order to return to the menu before the gameplay
	pop_menu(2)

func _on_new_game_button_down():
	push_menu(Menu.gameplay)

################################################################################
## MENU DATA
################################################################################
enum Menu {

	## Editor modes
	gameplay,

	## Shown on top of editor
	level_complete,
	level_pause,
	level_failed,

	## Full screens, fully obstructing editor
	main,
	options,


	## Not a menu
	none
}
@onready var menu_attributes:Dictionary = {
	Menu.gameplay: {
		"gameplay_visible": true, ##TODO: replace with background id?? tween background colors/designs?
		"node": null,
		"pause_engine": false
	},
	Menu.main: {
		"gameplay_visible": false,
		"node": %MainMenu,
		"pause_engine": true
	},
	Menu.level_pause: {
		"gameplay_visible": false,
		"node": %LevelPauseMenu,
		"pause_engine": true
	},
	Menu.options: {
		"gameplay_visible": false,
		"node": %OptionsMenu,
		"pause_engine": true
	},
}






