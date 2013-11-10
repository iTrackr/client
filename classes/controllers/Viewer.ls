class Viewer extends IS.Object
	~> 
		@log "Viewer Created"
		@menu = new (DepMan.controller "Menu")!

	destroy: ~>
		@menu.destroy!; delete @menu

module.exports = Viewer