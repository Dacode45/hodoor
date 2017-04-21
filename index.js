var util = require("util"),
express = require("express"),
app = express(),
http = require("http").Server(app),
io = require('socket.io')(http),
path = require("path"),
fs = require("fs"),
spawn = require('child_process').spawn;

app.locals.lock_status = 'locked';
app.get("*", function(req,res){
	console.log("User has connected.");
	res.sendFile(__dirname + "/page.html");
	
});

var sockets = {};

var process = spawn('python',['/home/pi/hodoor/main.py']);
io.on('connection', function(socket){
	console.log("Socket " + socket.id + " has connected.");
	sockets[socket.id] = socket;
	console.log(Object.keys(sockets).length + " clients are connected.");
		


	socket.on('lock_status', function(){
		io.emit('lock_status', {status:app.locals.lock_status});
	});

	socket.on('toggle_lock', function(){
		var script;
		var result;
		if (app.locals.lock_status == 'locked'){
			script = '/home/pi/hodoor/lock.py';
			result = 'unlocked';
		}else if (app.locals.lock_status == 'unlocked'){
			script = '/home/pi/hodoor/lock.py';
			result = 'locked';
		}
		var process = spawn('python',[script]);
		process.stdout.on('data', function(data){
			console.log(data.toString());
		});
		process.stdout.on('end', function(){
			console.log('python script done');
			if (process) process.kill();
		});
		app.locals.lock_status = result;
		io.emit('toggle_lock', {status: "ok"});
	
	});
	
	socket.on('script', function(){
		console.log('calling python script');
		var process = spawn('python',['/home/pi/hodoor/test.py']);
		process.stdout.on('end', function(){
			console.log('finished');
			if (process){
				console.log('killing');
				process.kill();
			}
		});
		
	});	

	socket.on('disconnect', function(){
		console.log("Socket has disconnected.");
		delete sockets[socket.id];
		console.log(Object.keys(sockets).length + " clients are connected.");
	});


});


http.listen(80, function(){
	console.log("LISTENING on port 80.");
});


