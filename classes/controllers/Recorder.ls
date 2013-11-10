class Recorder extends IS.Object
	~> 
		@log "Initializing Recorder"
		@grid = new (DepMan.model "grid")
		@buffer = new (DepMan.model "buffer")
		@hook-events!

	hook-events: ~>
		window.addEventListener "mousemove", @move
		window.addEventListener "touchmove", @move
		window.addEventListener "scroll", @scroll
		window.addEventListener "click", @click
		window.addEventListener "touchstart", @click
		window.addEventListener "touchend", @click

	normalize: ~> it.touches?[0] or it

	move: ~>
		if @timer 
			if @wait-count 
				@buffer.queue \hover, @last-pos, @wait-count
				clearInterval @timer
				delete @wait-count
			else clearTimeout @timer
		point = @normalize it
		group = @grid.translate-point x: point.clientX + window.scrollX, y: point.clientY + window.scrollY
		@last-pos = group
		@buffer.queue \move, @last-pos
		@timer = setTimeout ~>
			@wait-count = 1
			count = ~> @wait-count++
			@timer = setInterval count, 500
		, 50

	scroll: ~>
		point = @normalize it
		group = @grid.translate-scroll!
		@buffer.queue \scroll, group

	click: ~>
		point = @normalize it
		group = @grid.translate-point x: point.clientX + window.scrollX, y: point.clientY + window.scrollY
		@buffer.queue \click, group

	destroy: ~>
		@log "Destroying"
		@grid.destroy!; delete @grid
		@buffer.destroy!; delete @buffer
		window.removeEventListener "mousemove", @move
		window.removeEventListener "touchmove", @move
		window.removeEventListener "scroll", @scroll
		window.removeEventListener "click", @click

module.exports = Recorder