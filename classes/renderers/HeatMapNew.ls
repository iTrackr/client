class HeatMapNewRenderer extends IS.Object
	(@opts) ~>
		@buffer = document.createElement "div"
		@log "Heatmap Created" 
		@buffer.id = "heatmap-canvas"
		@grid = new (DepMan.model "grid")
		@id = "normal"
		config = 
				element: @buffer
				radius: 30
				opacity: 50
		@heatmap = h337.create config
		@resize!; window.addEventListener "resize", @resize
		document.body.appendChild @buffer
	destroy: ~>
		window.removeEventListener "resize", @resize
		@grid.destroy!; delete @grid
		document.body.removeChild @buffer; delete @buffer
	sequence: ~>
		@resize!
		sortable = @get-sets it
		views = data :[], max: sortable[0][1]
		for set in sortable
			index = @grid.untranslate-point set[0]
			views.data.push x: index.x - 12.5, y: index.y - 12.5, count: set[1]
		@log "Setting data", views
		@heatmap?.store.set-data-set views
	resize: ~>
		@buffer.setAttribute "style", "width: #{document.body.scrollWidth}px; height: #{document.body.scrollHeight}px;"
		@heatmap.resize document.body.scrollWidth, document.body.scrollHeight

	get-sets: ->
		sortable = []; set = {}
		for opt, onn of @opts when opt isnt \scroll
			for key, value of it[opt]
				if not set[key] then set[key] = value * onn
				else set[key] += value * onn
		for key, value of set
			sortable.push [key, value]
		sortable.sort (a, b) -> b[1] - a[1]
		if @opts.scroll
			scrolls = it.scroll; 
			sets = sortable
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
						blockindex = @grid.deform-point x: blockset[0], y: blockset[1]; index = @grid.deform-scroll x: set[0], y: set[1]
						if blockindex.y >= index.y and blockindex.y <= index.y + window.innerHeight 
							blockset.1 *= set.3
			sortable = sets
		sortable



module.exports = HeatMapNewRenderer
