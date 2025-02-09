class_name WorldMap

var main: Main
var width: int
var height: int
var cells = []

func _init(width, height, main):
	self.width = width
	self.height = height
	self.cells.resize(width * height)
	self.main = main

func set_cell(x, y, cell):
	var index = y * width + x
	cells[index] = cell

func get_cell(coords: Vector2i) -> MapCell:
	if coords.x >= width || coords.x < 0:
		coords.x = ((coords.x % width) + width) % width
	if coords.y >= height || coords.y < 0:
		coords.y = ((coords.y % height) + height) % height
	var index = coords.y * width + coords.x
	return cells[index]

func get_tiles_in_range(center: Vector2i, available_movement: int) -> Array:
	var reachable_tiles = []  # Stores valid movement tiles
	var queue = [{ "pos": center, "remaining_moves": available_movement}]  # BFS queue
	var visited = {}  # Stores checked positions

	while queue.size() > 0:
		var current = queue.pop_front()
		var pos = current["pos"]
		var remaining_moves = current["remaining_moves"]

		if visited.has(pos) or remaining_moves < 0:
			continue

		visited[pos] = true

		var cell = get_cell(pos)
		if cell == null or not cell.visibility:  # Skip if not visible
			continue

		reachable_tiles.append(pos)

		for neighbor in get_neighbors(pos):
			var movement_cost = get_cell(neighbor).get_movement_cost()
			if remaining_moves >= movement_cost:
				queue.append({ "pos": neighbor, "remaining_moves": remaining_moves - movement_cost }) 
	return reachable_tiles


func find_path(start: Vector2i, target: Vector2i) -> Array:
	var open_set = []  # Nodes to explore (priority queue)
	var came_from = {}  # Stores where we came from
	var g_score = {}  # Cost from start to each node
	var f_score = {}  # Estimated total cost (g + heuristic)
	open_set.append(start)
	g_score[start] = 0
	f_score[start] = heuristic(start, target)

	while open_set.size() > 0:
		open_set.sort_custom(func(a, b): return f_score.get(a, INF) < f_score.get(b, INF))
		var current = open_set.pop_front()  # Get node with lowest f_score

		if current == target:
			return reconstruct_path(came_from, current)  # Build final path

		for neighbor in get_neighbors(current):
			var movement_cost = get_cell(neighbor).get_movement_cost()
			var tentative_g = g_score.get(current, INF) + movement_cost

			if tentative_g < g_score.get(neighbor, INF):  # Found a cheaper path
				came_from[neighbor] = current
				g_score[neighbor] = tentative_g
				f_score[neighbor] = tentative_g + heuristic(neighbor, target)

				if neighbor not in open_set:
					open_set.append(neighbor)

	return []  # No valid path found

func heuristic(a: Vector2i, b: Vector2i) -> float:
	return abs(a.x - b.x) + abs(a.y - b.y)  # Manhattan Distance
	
func get_neighbors(pos: Vector2i) -> Array:
	var neighbors = []
	var offsets = [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]  # Cardinal directions

	for offset in offsets:
		var neighbor_pos = pos + offset
		if is_within_bounds(neighbor_pos):  # Ensure it's within the map
			neighbors.append(neighbor_pos)

	return neighbors

func is_within_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < width and pos.y >= 0 and pos.y < height

func reconstruct_path(came_from: Dictionary, current: Vector2i) -> Array:
	var path = [current]
	while current in came_from:
		current = came_from[current]
		path.append(current)
	path.reverse()
	return path
