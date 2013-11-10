options = 
	\click : 0
	\hover : 0
	\move : 0
	\scroll : 0
class MenuController extends IS.Object
	~> 
		@log "Menu Controller Created"
		@placeholder = document.createElement "div"
		@placeholder.innerHTML = DepMan.render "menu"
		@log @placeholder
		document.body.appendChild @placeholder
		$ 'body' .addClass "itmenuactive"
		[\click \hover \move].map ~> 
			$ "##{it}-heat" .click (e) ~>
				@log "Should start #{it}-heat"
				$ '#optimised-heat' .removeClass "add"
				switch options[it]
				| 0 then options[it] = 1; $ "##{it}-heat" .removeClass "inactive" .addClass "add"
				| 1 then options[it] = -1; $ "##{it}-heat" .removeClass "add" .addClass "remove" 
				| -1 then options[it] = 0; $ "##{it}-heat" .removeClass "remove" .addClass "inactive"
				unless @heatmap and @heatmap.id and @heatmap.id is "normal"
					@release-heatmap!
					@heatmap = new (DepMan.renderer "HeatMapNew")(options)
		$ '#scroll-average' .click ~>
			if options[\scroll] 
				options.scroll = 0
				$ '#scroll-average' .removeClass 'add' .addClass 'inactive'
			else 
				options.scroll = 1
				$ '#scroll-average' .removeClass 'inactive' .addClass 'add'
		$ '#optimised-heat' .click ~>
			@release-heatmap!
			[\click \hover \move \scroll].map ~> 
				$ "##{it}-heat" .removeClass "inactive" .removeClass "add" .removeClass "remove"
				options[it] = 0
			$ '#optimised-heat' .addClass "add"
			@heatmap = new (DepMan.renderer "HeatMapOptimised")()
		$ '#remove-heat' .click ~> 
			$ '#optimised-heat' .removeClass "add"
			[\click \hover \move \scroll].map ~> 
				$ "##{it}-heat" .removeClass "inactive" .removeClass "add" .removeClass "remove"
				options[it] = 0
			@release-heatmap!
		@scroll-average = $ '#scroll-average span'
		DepMan.helper "EncodingUtils"
		DepMan.helper "DataTransfer"
		@grid = new (DepMan.model "grid")
		@init-transfers!
	release-heatmap: ~>
		if @heatmap 
			@heatmap.destroy!
			delete @heatmap
	init-transfers: ~>
		@interval = setInterval @query, 1000
		iTTransfer.socket.on "receiveData", @transfer
		iTTransfer.socket.on "receiveIPs", @refresh-select
	query: ~> 
		console.log ($ '#ip-select' .val!)
		iTTransfer.socket.emit "requestData", ($ '#ip-select' .val!) or 'aggregated'
		iTTransfer.socket.emit "requestIPs"
	transfer: ~>
		unless it.data is "404"
			data = Utils.decode-data it.data
			if @heatmap then @heatmap.sequence data
			sortable = []
			for key, value of data.scroll
				key = key.split ","
				sortable.push [key[0], key[1], value]
			sortable.sort (a, b) -> b[2] - a[2]
			if sortable[0] then @scroll-average.html parseInt ((@grid.untranslate-scroll sortable[0]).x / document.body.scrollHeight * 100 )
	refresh-select: ~>
		it.unshift "aggregated"
		items = []
		for item in it
			selected = if (it.indexOf item) is 0 then " selected=\"true\"" else ""
			items.push "<option value=\"#{item}\"#{selected}>#{item}</option>"
		select = $ '#ip-select'
		local = select.html!; items = items * "\n"
		if local isnt items
			select.empty!html items



	destroy: ~>
		document.body.removeChild @placeholder
		$ 'body' .removeClass 'itmenuactive'
		@release-heatmap!
		clearInterval @interval
		iTTransfer.socket.removeAllListeners "receiveData"
		iTTransfer.socket.removeAllListeners "receiveIPs"
		@grid.destroy!; delete @grid

module.exports = window.iTViewController = MenuController