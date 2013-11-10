class Buffer extends IS.Object
	~> 
		DepMan.helper "DataTransfer"
		DepMan.helper "EncodingUtils"
		@reset!
		@timer = setInterval @flush, 1000
	queue: (what, data, step = 1) ~> 
		@buffers[what][data] ?= 0
		@buffers[what][data] += step
	flush: ~> 
		data = Utils.encode-data {
			move: @buffers.move
			hover: @buffers.hover
			scroll: @buffers.scroll
			click: @buffers.click
		}
		@log data
		iTTransfer.send data
		@reset!
	reset: ~>
		@buffers = move: {}, scroll: {}, click: {}, hover: {}
	destroy: ~>
		@flush!
		clearInterval @timer

module.exports = Buffer