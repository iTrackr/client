const STATES = [\view \record]; States = new IS.Enum STATES
class StateMachine extends IS.Object
	~> 
		@activate-state States.record
		key = if Tester.mac then "cmd" else "ctrl"
		jwerty.key "#{key}+shift+alt+tab", @toggle-state
	activate-state: (state) ~>
		unless STATES[state]? is false
			@["activateState#{STATES[state]}"]!
			@state = state
	deactivate-state: (state) ~>
		state ?= @state
		unless STATES[state]? is false
			@["deactivateState#{STATES[state]}"]!
			@state = null
	other-state: (state) ~> switch state
	| States.view => States.record
	| otherwise => States.view
	toggle-state: ~>
		unless iTLock.isLocked
			state = @state
			@deactivate-state!
			@activate-state @other-state state

	activate-stateview: ~>
		@log "Activating View State" 
		window.iTViewer = new (DepMan.controller "Viewer")
	deactivate-stateview: ~>
		@log "Deactivating View State" 
		window.iTViewer.destroy!; delete window.iTViewer

	activate-staterecord: ~>
		@log "Activating Record State" 
		window.iTRecorder = new (DepMan.controller "Recorder")
	deactivate-staterecord: ~>
		@log "Deactivating Record State" 
		window.iTRecorder.destroy!; delete window.iTRecorder

	@include IS.Modules.Observer

module.exports = StateMachine