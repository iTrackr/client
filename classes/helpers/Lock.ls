class Lock extends IS.Object
	(@isLocked = true) ~> 
	unlock: ~>
		if @isLocked
			Modal.show title: "Unlock the application.", content: DepMan.render "unlock"
			$ '#unlockpassword' .change Modal.hide
			$ '#unlockbutton' .click Modal.hide
			$ '#unlockpassword' .focus!
			id = Modal.subscribe "prehide", ~>
				val = $ '#unlockpassword' .val!
				if val is 'meinpenis' 
					iTStateMachine.toggleState!
					@isLocked = false
				else alert "Wrong answer!"
				Modal.unsubscribe id
				div = document.createElement "div"
				div.id = "unlockedplaceholder"
				div.innerHTML = "<i class='icon-eye-open'></i>"
				$ div .click ~> 
					item = document.get-element-by-id 'itmenuwindow'
					if item then $ item .toggleClass 'inactive'
				iTStateMachine.toggleState!
				document.body.appendChild div
		else @lock!
	lock: ~> 
		@isLocked = true
		div = $ '#unlockedplaceholder' .0
		if div then div.remove!

module.exports = Lock