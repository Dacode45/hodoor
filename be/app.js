var express = require('express'),
  bodyParser = require('body-parser'),
  cookieParser = require('cookie-parser'),
  session = require('express-session'),
  http = require('http'),
  db = require ('sqlite'),
  path = require('path'),

  Promise = require('bluebird')

var app = express();
app.use(bodyParser);
app.use(cookieParser);
const port = 3000;

app.post

Promise.resolve()
  .then(function(){
    db.open('./database.sqlite', { Promise })
  })
  .then(function(){
    db.migrate({force: 'last'})
  })
  .catch(function(err){
    console.error(err.stack);
  })
  .finally(function(){
    app.listen(port);
  })
