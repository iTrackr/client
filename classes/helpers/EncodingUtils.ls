class Utils
	@decode-data = (data) ~>
		pieces = data.split "|"; data = {}
		for piece in pieces
			if (piece.indexOf "<HOVER>") is 0 then data.hover = @decode-piece piece.substr 7
			if (piece.indexOf "<SCROLL>") is 0 then data.scroll = @decode-piece piece.substr 8
			if (piece.indexOf "<CLICK>") is 0 then data.click = @decode-piece piece.substr 7
			if (piece.indexOf "<MOVE>") is 0 then data.move = @decode-piece piece.substr 6
		data
	@decode-piece = (data) ~>
		return if data is ""
		pieces = data.split ";"; data = {}
		for piece in pieces
			[key, value] = piece.split ":"
			data[key] = parseInt(value)
		data
	@encode-data = (data) ~> "<HOVER>#{@encode-piece data.hover}|<SCROLL>#{@encode-piece data.scroll}|<CLICK>#{@encode-piece data.click}|<MOVE>#{@encode-piece data.move}"
	@encode-piece = (data) ~>
		obj = []
		for key, value of data 
			unless not value
				obj.push "#{key}:#{value}"
		obj.join ";"

module.exports = Utils
if root? then root.Utils = Utils
if window? then window.Utils = Utils