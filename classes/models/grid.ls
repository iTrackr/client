class Grid extends IS.Object
	translate-point: ~> [(@form-point it.x - window.innerWidth / 2), (@form-point it.y)]
	translate-scroll: ~> [(@form-scroll window.scrollY), (@form-scroll window.scrollX)] 
	form-point: ~> @form it, 25
	form-scroll: ~> @form it, 250
	form: (obj, margin) ~> parseInt(obj / margin) + (obj % margin isnt 0)	
	deform: (obj, margin) ~> x: obj.x * margin + window.innerWidth / 2, y: obj.y * margin
	deform-point: ~> @deform it, 25
	deform-scroll: ~> @deform it, 250
	untranslate-point: ~>
		it = it.split ","
		@deform-point x: it[0], y: it[1]
	untranslate-scroll: ~>
		@deform-scroll x: it[0], y: it[1]
	destroy: ~>


module.exports = Grid
