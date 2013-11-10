_base = "http://192.168.137.232:80/"
_devbase = "http://192.168.0.4:80/"
_base = _devbase
class DataTransfer extends IS.Object
	(cb) ~> 
		script = document.create-element "script"
		script.src = "#{_base}socket.io/socket.io.js"
		script.onload = ~>
			@socket = io.connect _base
			@socket.emit "begin", host: window.location.toString!substr 7
			cb?!
		@log script
		document.body.append-child script

	send: ~>
		@socket?.emit "sendData", it

module.exports = DataTransfer