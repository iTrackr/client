
join = (a, b) ~>
	for key, value of a
		if b[key]? then b[key] += a[key]
		else b[key] = a[key]
	b

passthrough = (sets, scrolls, grid)~>
	sortable = []
	for key, value of scrolls
		key = key.split ","
		sortable.push [key[0], key[1], value]
	sortable.sort (a, b) -> b[2] - a[2]
	if sortable.length
		max = sortable[0][2]
		for set in sortable then set.push set[2] / max
		for set in sortable
			for blockset in sets
				blockindex = grid.deform-point x: blockset[0], y: blockset[1]; index = grid.deform-scroll x: set[0], y: set[1]
				if blockindex.y >= index.y and blockindex.y <= index.y + window.innerHeight 
					blockset.1 *= set.3
	sets

class HeatMapCombined extends DepMan.renderer "HeatMapNew"
	~> super it or "joined"
	get-sets: ->
		it.move ?= {}
		it.click ?= {}
		it.hover ?= {}
		it.scroll ?= {}
		sets = join it.move, it.click
		sets = join sets, it.hover
		sortable = []
		for key, value of sets
			sortable.push [key, value]
		sortable.sort (a, b) -> b[1] - a[1]
		sets = sortable
		sets = passthrough sets, it.scroll, @grid
		console.log sets
		sets


module.exports = HeatMapCombined
