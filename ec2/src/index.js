'use strict';

require('./style.css');
// Require index.html so it gets copied to dist
require('./index.html');

var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

// .embed() can take an optional second argument. This would be an object describing the data we need to start a program, i.e. a userID or some token
var url = process.env.URL;
var port = process.env.PORT;
var baseUrl = `${url}`;
baseUrl = (port)? baseUrl + `:${port}` : baseUrl;
var socketUrl = `ws://${baseUrl}`;
var httpUrl = `http://${baseUrl}`;
console.log(process.env)
console.log('http, socket', httpUrl, socketUrl);
var app = Elm.Main.embed(mountNode, {
  socketUrl: socketUrl,
  httpUrl: httpUrl
});
