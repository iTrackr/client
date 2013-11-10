Object.getPrototypeOf(document.createElement("canvas").getContext("2d")).fillRectR = (x, y, w, h, r) ->
	r = 5	if typeof r is "undefined"
	@beginPath()
	@moveTo x + r, y
	@lineTo x + w - r, y
	@quadraticCurveTo x + w, y, x + w, y + r
	@lineTo x + w, y + h - r
	@quadraticCurveTo x + w, y + h, x + w - r, y + h
	@lineTo x + r, y + h
	@quadraticCurveTo x, y + h, x, y + h - r
	@lineTo x, y + r
	@quadraticCurveTo x, y, x + r, y
	@closePath()
	@fill()

Object.getPrototypeOf(document.createElement("canvas").getContext("2d")).strokeRectR = (x, y, w, h, r) ->
	r = 5	if typeof r is "undefined"
	@beginPath()
	@moveTo x + r, y
	@lineTo x + w - r, y
	@quadraticCurveTo x + w, y, x + w, y + r
	@lineTo x + w, y + h - r
	@quadraticCurveTo x + w, y + h, x + w - r, y + h
	@lineTo x + r, y + h
	@quadraticCurveTo x, y + h, x, y + h - r
	@lineTo x, y + r
	@quadraticCurveTo x, y, x + r, y
	@closePath()
	@stroke()

class BaseFrameBuffer extends IS.Object
	(@buffer) ~>
		unless @buffer then @buffer = document.createElement("canvas")
		@sbuffer = document.createElement("canvas")
		@context = @buffer.getContext "2d"
		@scontext = @sbuffer.getContext "2d"
	reset: ~> @buffer.width = @buffer.width

module.exports = BaseFrameBuffer