const DRIVERS = [\webkit \normal]; Drivers = new IS.Enum DRIVERS

class iTNotificationHelper extends IS.Object
	~> 

		@timeout ?= 5000

		@driver = DRIVERS.normal
		if Tester[\webkitiTNotifications]
			unless Tester[\chrome.storage]
				handler = ->
					webkitiTNotifications.requestPermission()
					window.removeEventListener "click"
				window.addEventListener "click", handler
			@driver = DRIVERS.webkit	
		@echo "iTNotification Helper Online, with driver : ", @drive, " and timeout : ", @timeout

	toast: (title = "iTNotification", ...body)~> switch @driver
	| Drivers.webkit => 
		if webkitiTNotifications.checkPermission() is 0 
			@toast-webkit title, body 
		else @toast-normal title, body
	| otherwise => @toast-normal title, body
	toast-webkit: (title, body)~>
		b = body.shift!
		for item in body then b += "\n#item"
		notif = webkitiTNotifications.createiTNotification 'icon.ico', title, b 
		notif.ondisplay = (ev) -> setTimeout (-> ev.currentTarget.cancel()), @timeout
		notif.show!
	toast-normal: (title, body) ~>
		b = ""
		if Modal? 
			for item in body then b += "<p>#item</p>"
			Modal.show {title: title, content: b}, @timeout
		else 
			b = ( [title] ++ body ) * "\n"
			alert b

Helper = new iTNotificationHelper()
iTToast = Helper.toast
module.exports = [ Helper, iTToast ]
