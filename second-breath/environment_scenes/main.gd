extends Node

const PickUp = preload("res://item/pick_up/pick_up.tscn")

@onready var player: CharacterBody3D = $Player
@onready var inventory_interface: Control = $UI/InventoryRoot/InventoryInterface
@onready var inventory_root: Control = $UI/InventoryRoot
@onready var hot_bar_inventory: PanelContainer = $UI/HotBarInventory
@onready var talent_tree: TalentTree = $UI/talent_tree


func _ready() -> void:
	player.toggle_inventory.connect(toggle_inventory_root)
	player.toggle_skilltree.connect(toggle_skilltree_interface)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	inventory_interface.set_equip_inventory_data(player.equip_inventory_data)
	inventory_interface.force_close.connect(toggle_inventory_root)
	hot_bar_inventory.set_inventory_data(player.inventory_data)
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_root)


func toggle_skilltree_interface() -> void:
	talent_tree.visible = not talent_tree.visible
	if talent_tree.visible:
		hot_bar_inventory.hide()
	else:
		hot_bar_inventory.show()

func toggle_inventory_root(external_inventory_owner = null) -> void:
	inventory_root.visible = not inventory_root.visible
	
	if inventory_root.visible:
		hot_bar_inventory.hide()
	else:
		hot_bar_inventory.show()
	
	if external_inventory_owner and inventory_root.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()


func _on_inventory_interface_drop_slot_data(slot_data: SlotData) -> void:
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = player.get_drop_position()
	add_child(pick_up)
