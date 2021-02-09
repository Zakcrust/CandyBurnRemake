extends Resource

class_name CharacterInventory

var items : Array = []
var coins : int = 0 setget set_coins, get_coins

func _init(items_init : Array = [], coins_init : int = 0):
	items = items_init
	coins = coins_init


func add_item(item) -> void:
	items.append(item)
	print(item)
	flush_intentory()

func remove_item(item) -> void:
	items.remove(item)
	flush_intentory()

func get_item(_item):
	for item in items:
		if item == _item:
			return item
	return null


func get_weapon(weapon_id : String) -> WeaponStats:
	for item in items:
		if item is WeaponStats:
			if item.weapon_id == weapon_id:
				return item
	return null


func flush_intentory() -> void:
	for item in items:
		if item == null:
			items.erase(item)
	print(items)


func add_coins(amount : int) -> void:
	coins += amount

func take_coins(amount : int) -> void:
	coins -= amount

func set_coins(amount : int) -> void:
	coins = amount

func get_coins() -> int:
	return coins

func drop_all_items() -> Array:
	return items
