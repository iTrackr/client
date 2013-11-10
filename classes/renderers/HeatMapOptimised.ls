len = (obj) ->
	nr = 0
	for key, value of obj then nr += 1
	nr
class HeatMapOptimised extends DepMan.renderer "HeatMapCombined"
	~> super "optimised"
	get-sets: ~>
		items = super it
		items = @map items
		items

	map: (@sets) ~>
		for set in @sets
			cords = set.0.split ","
			set.push @find 0, (parseInt cords.0) - 1
			set.push @find 0, (parseInt cords.0) + 1
			set.push @find 1, (parseInt cords.1) - 1
			set.push @find 1, (parseInt cords.1) + 1

		@zones = {}; @last-zone = 0
		@pings = 0
		while @sets.length > 0
			@add-zone!
		@log @pings

		sortable = []
		for zone, content of @zones
			arr = [zone, content._sum]
			for key, value of content
				if key isnt "_sum"
					arr.push key 
			sortable.push arr
		sortable.sort (a, b) -> b[1] - a[1]

		@sets = []; num = 0
		for set in sortable
			num += set.length - 3
			for index in [2 to (set.length - 1)]
				@sets.push [set[index], set.1]

		@sets

	add-zone: ~> 
		@move-zone @sets[0]
		@last-zone += 1

	move-zone: (node, dir = 0) ~>
		if node
			@zones[@last-zone] ?= _sum: 0
			@zones[@last-zone][node.0] = node.1
			@zones[@last-zone]._sum += node.1
			[2 to 5].map ~>
				prevdir = @change-dir dir
				nextdir = @change-dir it
				unless dir is prevdir
					next = node[it]
					node[it] = null
					if next
						next[nextdir] = null
						@move-zone next, it
			node.length = 2
			@sets.splice (@sets.indexOf node), 1

	change-dir: (dir) ~> switch dir
		| 2 => 3
		| 3 => 2
		| 4 => 5
		| 5 => 4

	find: (what, eq) ~>
		for set in @sets
			cords = set.0.split ","
			if (parseInt cords[what]) is eq then return set
		return null


module.exports = HeatMapOptimised
