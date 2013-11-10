const STATES = [\closed \normal \fullscreen]; States = new IS.Enum STATES

class ModalController extends IS.Object
	~>
		@state = States.closed
		@set-attributes!
		@render-modal!
		@hook-keyboard!
		@grab-controls!

	grab-controls: ~>
		@titlezone = $ '#modal-title-area'
		@contentzone = $ '#modal-content-area'
		@containerzone = $ '#modal-window' .0
		$ '#modal-close-button' .click ~> @hide!
		$ '#modal-fullscreen-botton' .click ~> @state = States.fullscreen; @safeApply! 

	render-modal: ~>
		div = document.createElement \div
		div.innerHTML = DepMan.render "modal", { States, STATES }
		div.setAttribute 'rel', "Modal Container"
		div.setAttribute \id, \modal-container
		document.body.appendChild div

	set-attributes: ~>
		@title = "Modal Window"
		@content = "Test Content"
		@queue = {}

	hook-keyboard: ~>
		jwerty.key "esc", ~> @hide!
		
	toggle: ~>
		if ( @state ) is States.normal then @state = States.fullscreen
		else @state = States.normal
		@safeApply!

	show: (data = {title: "No Title", content: "No Content"}, timeout) ~>
		@publish "preshow"
		@title = data.title or null
		@content = data.content or null
		if window.innerWidth <= 320 then @state = States.fullscreen
		else @state = States.normal
		if timeout then setTimeout @hide, timeout
		$ \body .add-class 'modal-active'
		@publish "show"
		@safeApply!

	hide: ~> @publish "prehide"; @state = States.closed; $ \body .remove-class 'modal-active'; @safeApply!publish "hide"
	set: (key, value) ~> if key in [\title \content] then @[key] = value; @safeApply!

	safeApply: ~>
		@titlezone.html @title
		@contentzone.html @content
		@containerzone.className = STATES[@state]
		@

	@include IS.Modules.Observer


Controller = new ModalController()
window.Modal = 
	set: -> Controller.edit.apply Controller, arguments
	show: -> Controller.show.apply Controller, arguments
	hide: -> Controller.hide.apply Controller, arguments
	subscribe: -> Controller.subscribe.apply Controller, arguments
	unsubscribe: -> Controller.unsubscribe.apply Controller, arguments
module.exports = Controller
