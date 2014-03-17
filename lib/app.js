var app, express;

express = require("express");

app = express();

app.configure('development', function() {
  console.log("DEVELOPMENT");
  return app.use(express["static"]("./build"));
});

app.configure('production', function() {
  console.log("PRODUCTION");
  app.use(express["static"]("./public"));
  return app.use(express.errorHandler({
    dumpExceptions: false,
    showStack: false
  }));
});

app.use(express.multipart({
  defer: true
}));

app.use(express.logger());

app.set('view engine', 'jade');

app.set('views', './views');

app.set('port', process.env.PORT || 3000);

app.use(express.errorHandler({
  dumpExceptions: true,
  showStack: true
}));

app.get("/", function(req, res) {
  console.log("index route");
  return res.render('index');
});

app.get("/upload", function(req, res) {
  console.log("POST: Upload route");
  return res.render('index');
});

app.post("/upload", function(req, res) {
  console.log("POST: Upload");
  return res.render('index');
});

app.listen(app.get('port'), function() {
  return console.log("FU Express server listening on port# " + process.env.PORT + " Environment " + process.env.NODE_ENV);
});

module.exports = app;
