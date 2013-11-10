class LanguageHelper extends IS.Object
	~>
		@echo "Initializing Language Controls"
		@_language = {}
		DBStorage.get "lang", (lang) ~>
			language = lang or "en-US"
			@switchLanguage language

	switchLanguage: (@language) ~>
		@echo "Switching language to #{@language}"
		try
			DepMan.language @language
			@_language = JSONImport["#{@language}"]
			DBStorage.set "lang", @language
			do @_translateAll
		catch e
			@_language = {}
			@log "Error Encountered", e

	_translate: (text) ~> @_language[text] or text
	_hook: (text, area = null) ~> 
		clearTimeout @timer
		@timer = setTimeout @_translateAll, 0
		string = "data-translate = '#{text}'"
		string += " data-target='#{area}'" if area?
		string
	_translateAll: ~>
		me = @
		jQuery("*[data-translate]").each (element) ->
			if @tagName is "INPUT"
				target = @dataset["target"] or "value"
				@[target] = me._translate @dataset["translate"]
			else @innerHTML = me._translate @dataset["translate"]

window.LanguageHelper = new LanguageHelper()
window.T = window.LanguageHelper._translate
window._T = window.LanguageHelper._hook
window.__T = window.LanguageHelper._translateAll
