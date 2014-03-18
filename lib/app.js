
/*
module dependencies
 */
var app, express, mongoose, secrets, uploadhandler;

express = require("express");

mongoose = require("mongoose");


/*
API keys + Passport configuration.
 */

secrets = require("./config/secrets");


/*
create express server
 */

app = express();


/*
Mongoose configuration.
 */

mongoose.connect(secrets.db);

mongoose.connection.on("error", function() {
  console.error("✗ MongoDB Connection Error. Please make sure MongoDB is running.");
});

app.configure('development', function() {
  console.log("DEVELOPMENT");
  app.use(express["static"]("./build"));
  return app.use(express.errorHandler({
    dumpExceptions: true,
    showStack: true
  }));
});

app.configure('production', function() {
  console.log("PRODUCTION");
  app.use(express["static"]("./public"));
  return app.use(express.errorHandler({
    dumpExceptions: false,
    showStack: false
  }));
});

app.use(express.logger());

uploadhandler = require("./uploader")(app, mongoose);

app.set('view engine', 'jade');

app.set('views', './views');

app.set('port', process.env.PORT || 3000);

app.set('env', process.env.ENV || "development");

app.use(express.responseTime());

app.use(express.json());

app.use(express.urlencoded());

app.use(app.router);

app.get("/", function(req, res) {
  console.log("index route");
  return res.render('index');
});

app.listen(app.get('port'), function() {
  return console.log("Express server listening on port# " + (app.get('port')) + " running in " + (app.get('env')) + " environment");
});

module.exports = app;
