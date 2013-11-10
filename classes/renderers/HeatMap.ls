class HeatMapRenderer extends DepMan.renderer "Base"
	(@prop) ~>
		super!
		@log "Heatmap Created" 
		@buffer.id = "heatmap-canvas"
		@grid = new (DepMan.model "grid")
		@resize!; window.addEventListener "resize", @resize
		document.body.appendChild @buffer
	destroy: ~>
		window.removeEventListener "resize", @resize
		@grid.destroy!; delete @grid
		@log @buffer
		document.body.removeChild @buffer; delete @buffer
	resize: ~>
		@buffer.width = document.body.scrollWidth
		@buffer.height = document.body.scrollHeight
	sequence: ~>
		@reset!
		sortable = @get-sets it
		@color = r: 256, g: 0, b: 0
		@last-value = 0
		for set in sortable
			index = @grid.untranslate-point set[0]
			alpha-delta = @color.r / 256 + @color.g / 256 + @color.b / 256
			if alpha-delta is 0 then alpha-delta = 0.1
			@context.fill-style = "rgba(#{@color.r}, #{@color.g}, #{@color.b}, #{alpha-delta})"
			@context.fill-rect index.x, index.y, 25, 25
			if @last-value is set.1
				if @color.r 
					@color.r -= 30
					if @color.r <= 20 then @color.r = 0; @color.g = 256
				else 
					if @color.g 
						@color.g -= 30
						if @color.g <= 20 then @color.g = 0; @color.b = 256
					else 
						if @color.b <= 20 then @color.b = 0
						else @color.b -= 30
			@last-value = set.1

	get-sets: ->
		sortable = []
		for key, value of it[@prop]
			sortable.push [key, value]
		sortable.sort (a, b) -> b[1] - a[1]
		sortable



module.exports = HeatMapRenderer
