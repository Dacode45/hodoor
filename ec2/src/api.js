var express = require('express');
var app = express();
var http = require('http');
var awsIot = require('aws-iot-device-sdk');
var path = require('path');
var url = require('url');
var proxy = require('proxy-request');
var WebSocket = require('ws');

var config = {
  keyPath: process.env.AWS_PRIVATE_KEY,
  certPath: process.env.AWS_CERTIFICATE,
  caPath: process.env.AWS_ROOTCA,
  clientId: process.env.AWS_CLIENT_ID,
  region: 'us-west-2',
}

var button = 0;
var locked = false;
var lockedTime = new Date();

app.use(express.static(path.join(__dirname, '../dist')));
app.get('/api/login/:id', function(req,res){
  var id = parseInt(req.params.id);
  if (id == button) {
    res.status(200).send({button: button, locked: locked, lockedTime: lockedTime});
  }else {
    res.status(400).send({error: "wrong id"});
  }
})

var regexView = /view\/(.+)/g;
app.get('/api/:id/view/*', function(req, res){
  var id = parseInt(req.params.id);
  if (id == button) {

    var match = req.originalUrl.split('view/');
    var url = (match && match[1])? `http://localhost:8081/picam/${match[1]}` : 'http://localhost:8081/picam';
    proxy(req, {url: url}, res)
  }
})

var server = http.createServer(app);
var wss = new WebSocket.Server({server});
var device = awsIot.device(config)

wss.brodcast = function(data) {
  wss.clients.forEach(function(client){
    if(client.readState === WebSocket.OPEN) {
      client.send(data);
    }
  })
}

wss.on('connection', function(ws){
  const location = url.parse(ws.upgradeReq.url, true);
  ws.on('message', function(data){
    data = (typeof data === 'string' || data instanceof String)? JSON.parse(data) : data;
    if (data.id === button) {
      console.log(data);
      var status = (data.lock)? 'lock' : 'unlock';
      device.publish(status, '');
    } else {
      ws.send("LOGOUT");
    }
  })
})

device.on('connect', function(){
  device.subscribe('button');
  device.subscribe('motion');
  device.subscribe('locked');
  device.subscribe('unlocked');
  device.publish('server', 'awake')
})

device.on('message', function(topic, payload){
  console.log('message', topic, payload.toString())
  switch (topic) {
    case 'button':
      button = parseInt(payload.toString())
    case 'motion':
      button = parseInt(payload.toString())
    case 'locked':
      lockUpdate(true, payload)
    case 'unlocked':
      lockUpdate(false,payload)
  }
})

function buttonUpdate(payload) {
  button = parseInt(payload.toString())
  wss.brodcast(JSON.stringify({kind: 'button', button:button}))
}

function lockUpdate(status, payload) {
  locked = status
  var time = parseInt(payload.toString());
  lockedTime = new Date(time*1000);
  wss.brodcast(JSON.stringify({kind: 'locked', locked:locked}))
}

server.listen(process.env.PORT, function listening(){
  console.log('Listening on %s %d', server.address(), server.address().port)
});
