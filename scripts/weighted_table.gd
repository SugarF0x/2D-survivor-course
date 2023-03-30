class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum = 0


func add_item(item, weight: int):
	items.append({ "item": item, "weight": weight })
	weight_sum += weight


func remove_item(upgrade):
	items = items.filter(func (upgrade_item):
		if upgrade.id != upgrade_item["item"].id: return true
		weight_sum -= upgrade_item["weight"]
		return false
	)


func pick_item(exclude: Array = []):
	var adjusted_items: Array[Dictionary] = items
	var adjusted_weight_sum = weight_sum
	
	if exclude.size() > 0 :
		adjusted_items = []
		adjusted_weight_sum = 0
		for item in items:
			if item["item"] in exclude: continue
			adjusted_items.append(item)
			adjusted_weight_sum += item["weight"]
	
	var chosen_weight = randi_range(1, adjusted_weight_sum)
	
	var iteration_sum = 0
	for item in adjusted_items:
		iteration_sum += item["weight"]
		if chosen_weight <= iteration_sum: return item["item"]
